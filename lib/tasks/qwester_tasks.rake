namespace :qwester do

  # Usage: rake data:reset_questionnaire_positions RAILS_ENV=production
  desc "Goes through each of the acts_as_list objects and resets the positions based on order they were added to the database"
  task :reset_questionnaire_positions => :environment do

    Qwester::Questionnaire.all.each do |questionnaire|
      first_id = questionnaire.questionnaires_questions.minimum(:id)
      if first_id   # nil if questionnaire has no questions
        sql = "UPDATE qwester_questionnaires_questions SET position = (1 + id - #{first_id}) WHERE questionnaire_id = #{questionnaire.id};"
        ActiveRecord::Base.connection.execute sql
      end
    end

    puts "Positions reset"
  end

  desc "Removes unpreserved answer stores"
  task :destroy_unpreserved_answer_stores => :environment do
    before = Qwester::AnswerStore.count
    Qwester::AnswerStore.destroy_unpreserved
    after = Qwester::AnswerStore.count
    puts "#{before - after} answer stores removed, with #{after} remaining."
  end
  
  desc "Reset positions of questionnaires within presentations"
  task :reset_presentation_questionnaires_positions => :environment do
    Qwester::Presentation.all.each do |presentation|
      presentation.presentation_questionnaires.each_with_index do |presentation_questionnaire, index|
        presentation_questionnaire.update_attribute(:position, index + 1)
      end
      puts "Presentation '#{presentation.name}' questionnaires postitioned #{presentation.presentation_questionnaires.collect(&:position)}"
    end
  end
end
