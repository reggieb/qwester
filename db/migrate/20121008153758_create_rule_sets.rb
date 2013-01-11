class CreateRuleSets < ActiveRecord::Migration
  def change
    create_table :qwester_rule_sets do |t|
      t.string :title
      t.string :description
      t.string :url
      t.timestamps
    end
    
    create_table :qwester_answers_rule_sets, :id => false do |t|
      t.integer :answer_id
      t.integer :rule_set_id
    end
  end
end
