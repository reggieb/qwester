# This migration comes from qwester (originally 20121120092108)
class AddIdsToQuestionnairesQuestions < ActiveRecord::Migration
  def up
    add_column qq_table, :id, :primary_key
    add_column qq_table, :position, :integer
    add_column qq_table, :created_at, :datetime
    add_column qq_table, :updated_at, :datetime

    execute "UPDATE #{qq_table} SET created_at = '#{Time.now.to_s(:db)}', updated_at = '#{Time.now.to_s(:db)}';"

    puts "=============================================="
    puts "Now run 'rake qwester:reset_positions RAILS_ENV=#{Rails.env}' to set the positions"
    puts "=============================================="
  end
  
  def down
    remove_column qq_table, :id
    remove_column qq_table, :position
    remove_column qq_table, :created_at
    remove_column qq_table, :updated_at
  end
  
  def qq_table
    :qwester_questionnaires_questions
  end
end
