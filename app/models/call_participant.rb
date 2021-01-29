# A model to store role and state for users participating in a jitsi call
class CallParticipant < ApplicationRecord
  VALID_STATES = %w[accepted rejected requested timeout].freeze
  VALID_ROLES = %w[initiator participant].freeze

  validates :state, inclusion: VALID_STATES
  validates :role, inclusion: VALID_ROLES

  belongs_to :user
  belongs_to :jitsi_call
end
