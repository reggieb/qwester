class RemoveQuestionnaireFromAnswer < ActiveRecord::Migration
  def up
    remove_column :qwester_answers, :questionnaire_id
  end

  def down
    add_column :qwester_answers, :questionnaire_id, :integer
  end
end
