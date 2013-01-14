module Qwester

  ActiveAdmin.register RuleSet do

    index do
      column :title
      column :answers do |rule_set|
        rule_set.answers.count
      end
      column :rule
      default_actions
    end

    form :partial => 'admin/rule_sets/form'

    show do
      render :template => 'admin/rule_sets/show'
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

  end if defined?(ActiveAdmin)

end