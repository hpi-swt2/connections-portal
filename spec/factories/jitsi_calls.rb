FactoryBot.define do
  factory :jitsi_call do
    room_name { SecureRandom.uuid }
  end
end
