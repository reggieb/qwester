# This migration comes from qwester (originally 20130306114331)
class AddPreservedToAnswerStores < ActiveRecord::Migration
  def change
    add_column :qwester_answer_stores, :preserved, :datetime
  end
end
