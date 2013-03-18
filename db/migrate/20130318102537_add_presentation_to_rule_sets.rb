class AddPresentationToRuleSets < ActiveRecord::Migration
  def change
    add_column :qwester_rule_sets, :presentation, :string
    add_column :qwester_presentations, :default, :boolean
  end
end
