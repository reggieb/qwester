module Qwester

  ActiveAdmin.register Answer do
    
    menu_label = 'Answers'
    menu_label = "Qwester #{menu_label}" unless Qwester.active_admin_menu
    menu :parent => Qwester.active_admin_menu, :label => menu_label

    actions :all, :except => [:edit]
    config.batch_actions = false

    index do
      column :id
      column :value
      column 'Question (edit answer via question)', :question do |answer|
        link_to(answer.question.title, edit_admin_qwester_question_path(answer.question)) if answer.question
      end
      column :position
      default_actions
    end
    
    member_action :move_up do
      answer = Answer.find(params[:id])
      answer.move_higher
      redirect_to admin_qwester_question_path(answer.question)
    end
    
    member_action :move_down do
      answer = Answer.find(params[:id])
      answer.move_lower
      redirect_to admin_qwester_question_path(answer.question)      
    end
    
    member_action :remove do
      answer = Answer.find(params[:id])
      answer.destroy
      redirect_to admin_qwester_question_path(answer.question) 
    end

  end if defined?(ActiveAdmin)

end