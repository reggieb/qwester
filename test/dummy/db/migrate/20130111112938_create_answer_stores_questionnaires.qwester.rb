# This migration comes from qwester (originally 20121204082213)
class CreateAnswerStoresQuestionnaires < ActiveRecord::Migration
  def change
    
    create_table :qwester_answer_stores_questionnaires, :id => false do |t|
      t.integer :questionnaire_id
      t.integer :answer_store_id
    end

  end
end
