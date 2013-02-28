namespace :qwester do

  # Usage: rake data:reset_positions RAILS_ENV=production
  desc "Goes through each of the acts_as_list objects and resets the positions based on order they were added to the database"
  task :reset_positions => :environment do



    Qwester::Questionnaire.all.each do |questionnaire|
      first_id = questionnaire.questionnaires_questions.minimum(:id)
      if first_id   # nil if questionnaire has no questions
        sql = "UPDATE qwester_questionnaires_questions SET position = (1 + id - #{first_id}) WHERE questionnaire_id = #{questionnaire.id};"
        ActiveRecord::Base.connection.execute sql
      end
    end



    puts "Positions reset"
  end


end
