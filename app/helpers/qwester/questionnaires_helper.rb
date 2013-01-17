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
      answer_store_answers.include? answer
    end

    def answer_store_answers
      @answer_store_answers ||= get_answer_store_answers
    end

    def get_answer_store_answers
      answer_store = get_qwester_answer_store 
      answer_store.answers
    end
  end
end
