module ActionController
  class Base < Metal
    
    protected
    def update_qwester_answer_store
      if params_includes_answers?
        get_qwester_answer_store(true)
        ActiveRecord::Base.transaction do
          add_answers_to_qwester_answer_store
          add_questionnaire_to_qwester_answer_store
          ensure_complete_all_questionnaires_completed
        end
      end
    end

    def get_qwester_answer_store(create_new = false)
      if session[Qwester.session_key]
        current_qwester_answer_store
      elsif create_new
        new_qwester_answer_store
      end
    end
    helper_method :get_qwester_answer_store

    def current_qwester_answer_store
      @qwester_answer_store = Qwester::AnswerStore.find_by_session_id(session[Qwester.session_key])
    end

    def new_qwester_answer_store
      set_qwester_answer_store Qwester::AnswerStore.create
    end
    
    def set_qwester_answer_store(answer_store)
      @qwester_answer_store = answer_store
      session[Qwester.session_key] = @qwester_answer_store.session_id
      @qwester_answer_store
    end
    
    def match_rule_sets
      if get_qwester_answer_store
        @qwester_rule_sets = Qwester::RuleSet.matching(@qwester_answer_store.answers)
        get_presentation_from_rule_sets
        return @qwester_rule_sets
      end
    end
    alias_method :matching_rule_sets, :match_rule_sets
        
    def current_questionnaires
      match_rule_sets
      presentation_questionnaires || default_presentation_questionnaires || Qwester::Questionnaire.all
    end
    
    def presentation_questionnaires
      @presentation = Qwester::Presentation.find_by_name(session[:presentations].last) if session[:presentations]
      @presentation.questionnaires if @presentation
    end
    
    def default_presentation_questionnaires
      @presentation = Qwester::Presentation.find_by_default(true)
      @presentation.questionnaires if @presentation
    end
    
    def get_presentation_from_rule_sets
      @qwester_rule_sets.clone.each do |rule_set|
        next unless rule_set.presentation?
        add_presentation_to_session rule_set.presentation
        @qwester_rule_sets.delete(rule_set)
      end
    end
    
    def add_presentation_to_session(presentation)
      session_presentations = session[:presentations] || []
      unless session_presentations.include? presentation
        session_presentations << presentation
        session[:presentations] = session_presentations
      end
    end
    
    def add_answers_to_qwester_answer_store
      answers = params[:question_id].values.collect do |question_values|
        question_values[:answer_ids].collect{|id| Qwester::Answer.find(id)}
      end
      answers.flatten!
      remove_answers_to_questions_answered_with(answers) if answers.present?
      @qwester_answer_store.answers = (@qwester_answer_store.answers | answers)      
    end
    
    def params_includes_answers?
      params[:question_id].kind_of?(Hash) and params[:question_id].values.present?
    end
    
    def remove_answers_to_questions_answered_with(answers)
      question_ids = answers.collect(&:question_id).uniq
      answers_to_delete = @qwester_answer_store.answers.collect {|a| a if question_ids.include? a.question_id.to_i}.compact
      @qwester_answer_store.answers.delete(answers_to_delete)
    end

    def add_questionnaire_to_qwester_answer_store
      @qwester_answer_store.questionnaires << @questionnaire
    end

    def ensure_complete_all_questionnaires_completed
      if @questionnaire.must_complete? and !@qwester_answer_store.completed_questionnaires.include?(@questionnaire)
        @questionnaire.errors.add(:base, "All questions must be answered in this questionnaire")
      end
      raise ActiveRecord::Rollback unless @questionnaire.errors.empty?
    end
  end
end
