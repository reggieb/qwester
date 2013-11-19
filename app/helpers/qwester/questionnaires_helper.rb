module Qwester
  module QuestionnairesHelper
    def qwester_answers_selection_list(question, list_class = 'qwester_options')
      button_name = "question_id[#{question.id}][answer_ids][]"
      answers = question.answers
      buttons = answers.collect do |answer|
        if question.multi_answer?
          button = check_box_tag(button_name, answer.id, answer_checked(answer))
        else
          button = radio_button_tag(button_name, answer.id, answer_checked(answer))
        end
        content_tag('li', "#{button}#{answer.value}".html_safe)
      end
      content_tag('ul', buttons.join.html_safe, :class => list_class)
    end

    def answer_checked(answer)
      answer_store_answers.include?(answer) || params_includes_answer(answer)
    end

    def answer_store_answers
      answer_store = get_qwester_answer_store
      answer_store ? answer_store.answers : []
    end

    # params should be of form: "question_id"=>{"1"=>{"answer_ids"=>["1"]}}
    def params_includes_answer(answer)
      question_ids = params[:question_id]
      return nil unless question_ids.kind_of? Hash
      answers = question_ids[answer.question_id.to_s]
      return nil unless answers.kind_of? Hash
      answers.values.flatten.include?(answer.id.to_s)
    end
  end
end
