module ActionController
  class Base < Metal
    
    protected
    def update_qwester_answer_store
      @qwester_answer_store = nil
      get_qwester_answer_store(true)
      add_answers_to_qwester_answer_store
      add_questionnaire_to_qwester_answer_store
      @qwester_answer_store.save
       p @qwester_answer_store.answers.collect &:id
       p Qwester::AnswerStore.last.answers.collect &:id
    end

    def add_answers_to_qwester_answer_store
      answers = params[:question_id].values.collect do |question_values|
        question_values[:answer_ids].collect{|id| Qwester::Answer.find(id)}
      end
      answers.flatten!
      question_ids = answers.collect(&:question_id).uniq
      before =  @qwester_answer_store.answers.collect &:id
      @qwester_answer_store.answers.delete_if {|a| question_ids.include? a.question_id.to_i}
      
      after = @qwester_answer_store.answers.collect &:id
      puts "#{before} > #{after} #{answers.collect &:id}"
      @qwester_answer_store.answers = (@qwester_answer_store.answers | answers)      
    end

    def add_questionnaire_to_qwester_answer_store
      @qwester_answer_store.questionnaires << @questionnaire
    end
    
    def get_qwester_answer_store(create_new = false)
      if session[:qwester_answer_store]
        current_qwester_answer_store
      elsif create_new
        new_qwester_answer_store
      end
    end
    helper_method :get_qwester_answer_store

    def current_qwester_answer_store
      @qwester_answer_store = Qwester::AnswerStore.find_by_session_id(session[:qwester_answer_store])
    end

    def new_qwester_answer_store
      set_qwester_answer_store Qwester::AnswerStore.create
    end
    
    def set_qwester_answer_store(answer_store)
      @qwester_answer_store = answer_store
      session[:qwester_answer_store] = @qwester_answer_store.session_id
    end
    
    def matching_rule_sets
      if get_qwester_answer_store
        Qwester::RuleSet.matching(@qwester_answer_store.answers)
      end
    end
  end
end
