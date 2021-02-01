FactoryBot.define do
  factory :meeting_invitation do
    state { MeetingInvitation::VALID_STATES.first }
    role { MeetingInvitation::VALID_ROLES.first }
    association :jitsi_call
    association :user
  end
end
