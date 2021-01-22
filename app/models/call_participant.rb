# A model to store role and state for users participating in a jitsi call
class CallParticipant < ApplicationRecord
  validates :state, inclusion: VALID_STATES
  validates :role, inclusion: VALID_ROLES

  belongs_to :user
  belongs_to :jitsi_call

  before_destroy do |participant|
    participant.jitsi_call.destroy if participant.jitsi_call.call_participants == 1
  end

  VALID_STATES = %w[accepted rejected timeout].freeze
  VALID_ROLES = %w[initiator participant].freeze
end
