module Qwester
  ActiveAdmin.register Presentation do

    menu_label = 'Presentations'
    menu_label = "Qwester #{menu_label}" unless Qwester.active_admin_menu
    menu :parent => Qwester.active_admin_menu, :label => menu_label  
    
    config.batch_actions = false
    
    index do
      column :name do |presentation| 
        link_to presentation.name, admin_qwester_presentation_path(presentation)
      end
      column :title
      column :default do |presentation|
        'default' if presentation.default?
      end
      column :questionnaires do |presentation|
        presentation.questionnaires.collect(&:title).join(', ')
      end
      default_actions
    end
    
    show do
      h2 qwester_presentation.title
      div sanitize(qwester_presentation.description) if qwester_presentation.description.present?
      qwester_presentation.questionnaires.each do |questionnaire|
        div(:style => 'display:inline-block;margin-right:20px;') do
          para image_tag(questionnaire.button_image.url(:thumbnail))
          para questionnaire.title
          move_up_link = "&nbsp;"
          move_down_link = "&nbsp;"
          unless qwester_presentation.first?(questionnaire)
            move_up_link =  link_to('<', move_up_admin_qwester_presentation_path(qwester_presentation, :questionnaire_id => questionnaire.id))
          end
          unless qwester_presentation.last?(questionnaire)
            move_down_link =  link_to('>', move_down_admin_qwester_presentation_path(qwester_presentation, :questionnaire_id => questionnaire.id))
          end
          para [move_up_link, 'move', move_down_link].join(' ').html_safe
        end
      end
      para "Default: Will be inital presentation of quesitonnaires" if qwester_presentation.default?
    end
    
    form do |f|
      f.inputs "Details" do
        f.input :name
        f.input :title, :label => "Title (or create from name)"
        f.input :default, :label => 'Set as default (that is, the first presentation displayed to a user). If no default, all questionnaires will be displayed'
        if defined?(Ckeditor)
          f.input :description, :as => :ckeditor, :input_html => { :height => 100}
        else
          f.input :description, :input_html => { :rows => 3}
        end
        f.input :questionnaires, :as => :check_boxes, :collection => Questionnaire.all
      end
      f.buttons
    end
    
    member_action :move_up do
      presentation = Presentation.find(params[:id])
      questionnaire = Questionnaire.find(params[:questionnaire_id])
      presentation.move_higher(questionnaire)
      redirect_to admin_qwester_presentation_path(presentation)      
    end
    
    member_action :move_down do
      presentation = Presentation.find(params[:id])
      questionnaire = Questionnaire.find(params[:questionnaire_id])
      presentation.move_lower(questionnaire)
      redirect_to admin_qwester_presentation_path(presentation)     
    end
    
  end
end
