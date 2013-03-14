# This migration comes from qwester (originally 20121204100803)
class AddLinkTextToRuleSets < ActiveRecord::Migration
  def change
    add_column :qwester_rule_sets, :link_text, :string
  end
end
