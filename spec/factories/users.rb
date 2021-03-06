FactoryBot.define do
  factory :user do
    email { "#{random_name}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    current_status { User.status_busy }
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

    trait :maximilian do
      firstname { 'Maximilian' }
      lastname { 'Mustermann' }
      username { 'berlin' }
      email { 'test@example.com' }
    end

    trait :erika do
      firstname { 'Erika' }
      lastname { 'Musterfrau' }
      username { 'london' }
      email { 'test2@example.com' }
    end
  end
end

def random_name
  ('a'..'z').to_a.shuffle.join
end
