# This migration comes from qwester (originally 20131119142009)
class AddMustCompleteToQwesterQuestionnaires < ActiveRecord::Migration
  def change
    add_column :qwester_questionnaires, :must_complete, :boolean
  end
end
