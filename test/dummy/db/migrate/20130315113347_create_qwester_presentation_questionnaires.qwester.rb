# This migration comes from qwester (originally 20130315113027)
class CreateQwesterPresentationQuestionnaires < ActiveRecord::Migration
  def change
    create_table :qwester_presentation_questionnaires do |t|
      t.integer :questionnaire_id
      t.integer :presentation_id

      t.timestamps
    end
  end
end
