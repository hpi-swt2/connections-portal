FactoryBot.define do
  factory :room_message do
    room { nil }
    user { nil }
    message { "MyText" }
  end
end
