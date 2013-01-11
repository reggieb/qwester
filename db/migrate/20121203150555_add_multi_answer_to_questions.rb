class AddMultiAnswerToQuestions < ActiveRecord::Migration
  def change
    add_column :qwester_questions, :multi_answer, :boolean
  end
end
