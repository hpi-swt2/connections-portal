namespace :devise do
  desc 'Create demo user'
  task create_demo_user: :environment do
    email = 'demo@example.com'
    pw = 'demo'
    # First off, see if there is a demo user already
    demo_user = User.find_by email: email

    # If a demo user was already found, no need to create another
    unless demo_user
      demo_user = FactoryBot.build(:user, email: email, password: pw, password_confirmation: pw)
      # Don't validate as the password is too short
      demo_user.save(validate: false)
      puts 'Created demo user'
    end

    puts "Demo user email: '#{demo_user.email}', password: '#{pw}'"
  end
end
