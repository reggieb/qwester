module Qwester

  ActiveAdmin.register Question do

    index do
      column :ref
      column :title do |question|
        link_to(question.title, '#', :title => question.description, :class => 'no_decoration')
      end
      column :answers do |question|
        question.answers.count
      end
      column :multi_answer do |question|
        question.multi_answer? ? 'Any' : 'One'
      end
      default_actions
    end

    show do
      para("References: #{question.ref}") if question.ref.present?
      para(question.description)
      h3 "Answers"
      para "User can select one#{' or many' if question.multi_answer?} of:"

      table :class => 'sortable_list' do
        tr do
          th 'Value'
        end
        question.answers.each do |answer|
          tr do
            td answer.value
            td(answer.first? ? "&nbsp;".html_safe : link_to('Up', move_up_admin_question_answer_path(question, answer)))
            td(answer.last? ? "&nbsp;".html_safe : link_to('Down', move_down_admin_question_answer_path(question, answer)))
            td link_to('Delete', remove_admin_question_answer_path(question, answer))
          end
        end
      end
    end

    form do |f|
      f.inputs "Details" do
        f.input :ref, :label => 'Reference'
        f.input :title
        f.input :description, :input_html => { :rows => 2}
        f.input :multi_answer, :label => 'User may select more than one answer to this question?'
      end

      f.inputs do
        f.has_many :answers do |answer_form|
          answer_form.input :value
          answer_form.input :position
          answer_form.input :cope_index
        end
      end

      f.buttons
    end

    controller do

      def new
        @question = Question.new
        @question.build_standard_answers
      end

      def move_up
        question = Question.find(params[:id])
        questionnaire = Questionnaire.find(params[:questionnaire_id])
        questionnaire.move_higher(question)
        redirect_to admin_questionnaire_path(questionnaire)
      end

      def move_down
        question = Question.find(params[:id])
        questionnaire = Questionnaire.find(params[:questionnaire_id])
        questionnaire.move_lower(question)
        redirect_to admin_questionnaire_path(questionnaire)
      end

    end

  end if defined?(ActiveAdmin)

end
