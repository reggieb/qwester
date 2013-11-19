class AddMustCompleteToQwesterQuestionnaires < ActiveRecord::Migration
  def change
    add_column :qwester_questionnaires, :must_complete, :boolean
  end
end
