class AddPositionToQwesterPresentationQuestionnaires < ActiveRecord::Migration
  def change
    add_column :qwester_presentation_questionnaires, :position, :integer
  end
end
