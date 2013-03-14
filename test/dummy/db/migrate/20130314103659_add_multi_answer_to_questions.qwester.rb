# This migration comes from qwester (originally 20121203150555)
class AddMultiAnswerToQuestions < ActiveRecord::Migration
  def change
    add_column :qwester_questions, :multi_answer, :boolean
  end
end
