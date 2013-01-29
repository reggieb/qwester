module Qwester

  ActiveAdmin.register RuleSet do
    
    menu_label = 'Rule Sets'
    menu_label = "Qwester #{menu_label}" unless Qwester.active_admin_menu
    menu :parent => Qwester.active_admin_menu, :label => menu_label

    index do
      column :title
      column :answers do |rule_set|
        rule_set.answers.count
      end
      column :rule
      default_actions
    end

    sidebar :rule_syntax do
      para 'R1 = "(a1 and a2) or (a3 and a4)"'

      para 'R2 = "a1 and not a2"'

      para 'R3 = "2 in a1 a2 a3"'

      para 'R4 = "(2 in a1 a2 a3) and (1 in a4 a5)"'

      table(:class => 'small') do
        tr do
          th "Input"
          th "R1"
          th "R2"
          th "R3"
          th "R4"
        end
        tr do
          th "[a1, a2]"
          th "true"
          th "false"
          th "true"
          th "false"
        end
        tr do
          th "[a3, a4]"
          th "true"
          th "false"
          th "false"
          th "false"
        end
        tr do
          th "[a1, a3, a5]"
          th "false"
          th "true"
          th "true"
          th "true"
        end      
      end

    end
    
    form do |f|
      f.inputs "Details" do
        f.input :title
        if defined?(Ckeditor)
          f.input :description, :as => :ckeditor, :input_html => { :height => 100, :toolbar => 'Basic' }
        else
          f.input :description, :input_html => { :rows => 3}
        end
      end
      
      f.inputs "Output Link" do
        f.input :url
        f.input :link_text        
      end
      
      f.inputs "Logic" do
        f.input :rule, :input_html => { :rows => 3}
      end
      
      f.inputs("Questions") do 
        
        if qwester_rule_set.questions.empty?
          
          f.input(
            :answers, 
            :as => :check_boxes, 
            :member_label => lambda {|a| "a#{a.id}: #{a.value} to '#{a.question.title}'"},
            :input_html => { :size => 20, :multiple => true}
          ) 
          
        else
          
          questions = qwester_rule_set.questions | Question.all
          questions.collect! do |question|
            style = 'border:#CCCCCC 1px solid;'
            html = [content_tag('td', question.title, :style => style)]
            answers = question.answers.collect do |answer|
              answer_style = style
              answer_style += 'background-color:#005C1F;color:white;font-weight:bold;' if qwester_rule_set.answers.include?(answer)
              content_tag('td', "a#{answer.id} #{answer.value}".html_safe, :style => answer_style).html_safe
            end
            html << answers.join(" ").html_safe
            content_tag('tr', html.join(" ").html_safe)
          end
          table_class = ["selection"]
          table_class << 'associated_questions' if qwester_rule_set.id.present?
          content_tag 'li', content_tag('table', questions.join("\n").html_safe, :class => table_class.join(' '))
        
        end
        
      end
      
      f.buttons
    end
    
    show do
      div do
        para sanitize(qwester_rule_set.description) 
      end if qwester_rule_set.description.present?
      
      div do
        h3 'Target url'
        para link_to qwester_rule_set.url
        para qwester_rule_set.link_text? ? qwester_rule_set.link_text : 'No link text specified'
      end
      
      div do
        h3 'The rule'
        para qwester_rule_set.rule
      end
      
      if qwester_rule_set.matching_answer_sets.present?
        div do
          h3 'Sample matching answer sets'
          if qwester_rule_set.matching_answer_sets.length
            para "There are at least #{qwester_rule_set.matching_answer_sets.length} combinations of answers that would pass this test."
          end
          para 'The following combinations of answers would pass'
          qwester_rule_set.matching_answer_sets.each do |answer_set|
            ul :style => 'border:#CCCCCC 1px solid;padding:5px;list-style:none;' do
              answer_set.each do |answer_id|
                next unless Answer.exists?(answer_id)
                answer = Answer.find(answer_id)
                question_summary = [answer.value, answer.question.title].join(' : ')
                li "(a#{answer_id}) #{question_summary}"
              end
            end
          end
        end
      else
        div do
          h3 'Matching answer sets'
          para 'Answers will pass unless they contain a blocking answer set'
        end
      end
      
      if qwester_rule_set.blocking_answer_sets.present?
        div do
          h3 'Sample blocking answer sets'
          para 'The following combinations of answers would not pass'
          qwester_rule_set.blocking_answer_sets.each do |answer_set|
             ul :style => 'border:#CCCCCC 1px solid;padding:5px;list-style:none;' do
              answer_set.each do |answer_id|
                next unless Answer.exists?(answer_id)
                answer = Answer.find(answer_id)
                question_summary = [answer.value, answer.question.title].join(' : ')
                li "(a#{answer_id}) #{question_summary}"
              end
            end
          end
        end
      else
        div do
          h3 'Blocking answer sets'
          para 'Answers will only pass if they contain a matching answer set'
        end
      end
      
    end  

  end if defined?(ActiveAdmin)

end