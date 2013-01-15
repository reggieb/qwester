module Qwester

  ActiveAdmin.register Question do
    
    menu_label = 'Questions'
    menu_label = "Qwester #{menu_label}" unless Qwester.active_admin_menu
    menu :parent => Qwester.active_admin_menu, :label => menu_label

    index do
      column :ref
      column :title do |qwester_question|
        link_to(qwester_question.title, '#', :title => qwester_question.description, :class => 'no_decoration')
      end
      column :answers do |qwester_question|
        qwester_question.answers.count
      end
      column :multi_answer do |qwester_question|
        qwester_question.multi_answer? ? 'Any' : 'One'
      end
      default_actions
    end

    show do
      para("References: #{question.ref}") if qwester_question.ref.present?
      para(qwester_question.description)
      h3 "Answers"
      para "User can select one#{' or many' if qwester_question.multi_answer?} of:"

      table :class => 'sortable_list' do
        tr do
          th 'Value'
        end
        qwester_question.answers.each do |answer|
          tr do
            td answer.value
            td(answer.first? ? "&nbsp;".html_safe : link_to('Up', move_up_admin_qwester_answer_path(answer)))
            td(answer.last? ? "&nbsp;".html_safe : link_to('Down', move_down_admin_qwester_answer_path(answer)))
            td link_to('Delete', remove_admin_qwester_answer_path(answer), :confirm => "Are you sure you want to delete the answer '#{answer.value}'?")
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
        @qwester_question = Question.new
        @qwester_question.build_standard_answers
      end

    end

  end if defined?(ActiveAdmin)

end
