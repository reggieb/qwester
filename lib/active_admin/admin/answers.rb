module Qwester

  ActiveAdmin.register Answer do

    actions :all, :except => [:edit]

    index do
      column :id
      column :value
      column 'Question (edit answer via question)', :question do |answer|
        link_to(answer.question.title, edit_admin_question_path(answer.question)) if answer.question
      end
      column :position
      column :cope_index
      default_actions
    end

    controller do

      before_filter :get_question_and_answer, :only => [:move_up, :move_down, :remove]

      def move_up
        @answer.move_higher
        redirect_to_answer_show
      end

      def move_down
        @answer.move_lower
        redirect_to_answer_show
      end

      def remove
        @answer.destroy
        redirect_to_answer_show
      end

      def add
        answer = Answer.find(params[:id])
        @rule_set = RuleSet.find(params[:rule_set_id])
        @rule_set.answers << answer
      end

      def delete
        answer = Answer.find(params[:id])
        @rule_set = RuleSet.find(params[:rule_set_id])
        @rule_set.answers.delete(answer)
      end

      private
      def get_question_and_answer
        @answer = Answer.find(params[:id])
        @question = Question.find(params[:question_id])
      end

      def redirect_to_answer_show
        redirect_to admin_question_path(@question)
      end

    end

  end if defined?(ActiveAdmin)

end