# This migration comes from qwester (originally 20121009080219)
class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :qwester_questionnaires do |t|
      t.string :title
      t.text :description
      t.timestamps
    end
    
    create_table :qwester_questionnaires_questions, :id => false do |t|
      t.integer :questionnaire_id
      t.integer :question_id
    end
  end
end
