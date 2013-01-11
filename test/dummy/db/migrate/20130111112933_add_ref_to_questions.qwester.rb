# This migration comes from qwester (originally 20121115114408)
class AddRefToQuestions < ActiveRecord::Migration
  def change
    add_column :qwester_questions, :ref, :string
  end
end
