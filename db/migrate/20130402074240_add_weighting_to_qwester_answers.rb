class AddWeightingToQwesterAnswers < ActiveRecord::Migration
  def change
    add_column :qwester_answers, :weighting, :float, :default => 0
  end
end
