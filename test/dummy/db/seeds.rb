require 'dibber'
Seeder = Dibber::Seeder

Seeder.seeds_path = "#{Rails.root}/db/seeds"

Seeder.monitor AdminUser
admin_email = 'admin@warwickshire.gov.uk'
password = 'changeme'
AdminUser.create!(
  :email => admin_email,
  :password => password,
  :password_confirmation => password
) unless AdminUser.exists?(:email => admin_email)

puts Seeder.report