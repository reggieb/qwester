module Qwester

  ActiveAdmin.register Answer do

    actions :all, :except => [:edit]

    index do
      column :id
      column :value
      column 'Question (edit answer via question)', :question do |answer|
        link_to(answer.question.title, edit_admin_qwester_question_path(answer.question)) if answer.question
      end
      column :position
      column :cope_index
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

#    controller do
#
#      before_filter :get_question_and_answer, :only => [:move_up, :move_down, :remove]
#


#
#      def add
#        answer = Answer.find(params[:id])
#        @rule_set = RuleSet.find(params[:rule_set_id])
#        @rule_set.answers << answer
#      end
#
#      def delete
#        answer = Answer.find(params[:id])
#        @rule_set = RuleSet.find(params[:rule_set_id])
#        @rule_set.answers.delete(answer)
#      end
#
#      private
#      def get_question_and_answer
#        @answer = Answer.find(params[:id])
#        @question = Question.find(params[:question_id])
#      end
#
#      def redirect_to_answer_show
#        redirect_to admin_question_path(@question)
#      end
#
#    end

  end if defined?(ActiveAdmin)

end