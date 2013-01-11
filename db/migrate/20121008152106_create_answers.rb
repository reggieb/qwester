class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :qwester_answers do |t|
      t.integer :question_id
      t.boolean :value
      t.timestamps
    end
  end
end