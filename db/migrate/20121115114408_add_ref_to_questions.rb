class AddRefToQuestions < ActiveRecord::Migration
  def change
    add_column :qwester_questions, :ref, :string
  end
end
