class AddPreservedToAnswerStores < ActiveRecord::Migration
  def change
    add_column :qwester_answer_stores, :preserved, :datetime
  end
end
