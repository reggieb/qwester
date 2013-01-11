# This migration comes from qwester (originally 20121122130930)
class AddCopeIndexAndPositionToAnswers < ActiveRecord::Migration
  def change
    add_column :qwester_answers, :position, :integer
    add_column :qwester_answers, :cope_index, :integer, :default => 0
  end
end
