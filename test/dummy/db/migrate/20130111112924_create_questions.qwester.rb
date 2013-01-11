# This migration comes from qwester (originally 20121008151526)
class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :qwester_questions do |t|
      t.string :title
      t.text :description
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.timestamps
    end
  end
end
