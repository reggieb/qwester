class AddLinkTextToRuleSets < ActiveRecord::Migration
  def change
    add_column :qwester_rule_sets, :link_text, :string
  end
end
