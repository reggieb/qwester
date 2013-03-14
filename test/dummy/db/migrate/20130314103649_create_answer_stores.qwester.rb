# This migration comes from qwester (originally 20121009095600)
class CreateAnswerStores < ActiveRecord::Migration
  def change
    create_table :qwester_answer_stores do |t|
      t.string :session_id
      t.timestamps
    end
    
    create_table :qwester_answer_stores_answers, :id => false do |t|
      t.integer :answer_id
      t.integer :answer_store_id
    end
  end
end
