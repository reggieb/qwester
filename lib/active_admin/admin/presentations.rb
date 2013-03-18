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
      qwester_presentation.questionnaires.each do |questionnaire|
        div(:style => 'display:inline-block;margin-right:20px;') do
          para image_tag(questionnaire.button_image.url(:thumbnail))
          para questionnaire.title
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
          f.input :description, :as => :ckeditor, :input_html => { :height => 100, :toolbar => 'Basic' }
        else
          f.input :description, :input_html => { :rows => 3}
        end
        f.input :questionnaires, :as => :check_boxes, :collection => Questionnaire.all
      end
      f.buttons
    end
    
  end
end
