require 'dibber'
Seeder = Dibber::Seeder

Seeder.seeds_path = "#{Rails.root}/db/seeds"

##############################
Seeder.monitor AdminUser
admin_email = 'admin@warwickshire.gov.uk'
password = 'changeme'
AdminUser.create!(
  :email => admin_email,
  :password => password,
  :password_confirmation => password
) unless AdminUser.exists?(:email => admin_email)

##############################
Seeder.monitor Qwester::Questionnaire
Seeder.monitor Qwester::Question
Seeder.monitor Qwester::Answer
Seeder.monitor Qwester::RuleSet
Seeder.process_log.start('first questionnaire questions', 'Qwester::Questionnaire.count > 0 ? Qwester::Questionnaire.first.questions.length : 0')

if Qwester::Questionnaire.count > 1
  puts "**** Bypassing questionnaire, question, answer and rule set population"
  puts "**** as there are already #{Qwester::Questionnaire.count} questionnaires in the system"
else
  Seeder.objects_from('questions.yml').each do |holder, data|
    questionnaire = Qwester::Questionnaire.find_or_create_by_title(data['title'])

    if data['questions']
      data['questions'].values.each do |question_data|
        question = Qwester::Question.find_or_create_by_title(question_data['question'])
        question.create_standard_answers
        answer = question.answers.find_or_create_by_value('Yes')
        rule_set = Qwester::RuleSet.find_or_initialize_by_title(question_data['title'])
        rule_set.url = question_data['url']
        rule_set.answers = [answer]
        rule_set.save
        questionnaire.questions << question
      end
    end
  end
end


##############################
puts Seeder.report