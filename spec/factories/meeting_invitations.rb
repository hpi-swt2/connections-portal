FactoryBot.define do
  factory :call_participant do
    state { CallParticipant::VALID_STATES.first }
    role { CallParticipant::VALID_ROLES.first }
    association :jitsi_call
    association :user
  end
end
