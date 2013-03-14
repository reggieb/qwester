# This migration comes from qwester (originally 20121122130930)
class AddPositionToAnswers < ActiveRecord::Migration
  def change
    # Adds unless clause, because original version of migration added another field
    # and file name was changed when this field was removed. This can cause this
    # migration to appear a second time if rake qwester:install:migrations is
    # run again in an app created before the change was made.
    unless column_exists?(:qwester_answers, :position)
      add_column :qwester_answers, :position, :integer
    end 
  end
end
