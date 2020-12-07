FactoryBot.define do
  factory :user do
    email { "#{random_name}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    current_status { 'working' }
    username { random_name }
    firstname { random_name }
    lastname { random_name }
    place_of_residence { 'Potsdam' }
    birthdate { Time.zone.today }

    factory :user_without_username do
      before(:create) do |user|
        user.username = nil
        user.init
      end
    end
  end
end

def random_name
  ('a'..'z').to_a.shuffle.join
end
