class CreateQwesterPresentations < ActiveRecord::Migration
  def change
    create_table :qwester_presentations do |t|
      t.string :name
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
