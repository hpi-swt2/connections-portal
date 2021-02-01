# A model to store role and state for users participating in a jitsi call
class MeetingInvitation < ApplicationRecord
  VALID_STATES = %w[accepted rejected requested timeout].freeze
  VALID_ROLES = %w[initiator guest].freeze

  validates :state, inclusion: VALID_STATES
  validates :role, inclusion: VALID_ROLES

  belongs_to :user
  belongs_to :jitsi_call

  VALID_STATES.each do |state|
    define_singleton_method :"state_#{state}" do
      state
    end
  end

  VALID_ROLES.each do |state|
    define_singleton_method :"state_#{state}" do
      state
    end
  end
end
