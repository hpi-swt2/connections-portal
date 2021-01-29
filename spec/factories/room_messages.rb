FactoryBot.define do
  factory :room_message do
    association :user
    message { "MyMessage: #{('a'..'z').to_a.shuffle.join}" }
    room { Room.global_chat_room }
  end
end
