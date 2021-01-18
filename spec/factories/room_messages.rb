FactoryBot.define do
  factory :room_message do
    association :room
    association :user
    message { 'MyMessage' }
  end
end
