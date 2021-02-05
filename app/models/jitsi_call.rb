# A model for storing jitsi calls initiated from contacts++
class JitsiCall < ApplicationRecord
  validates :room_name, presence: true

  has_many :meeting_invitations, dependent: :delete_all, inverse_of: :jitsi_call
  has_many :users, through: :meeting_invitations

  BASE_URL = Rails.configuration.jitsi['jitsi_url'].freeze

  def url
    "#{BASE_URL}/#{room_name}"
  end

  def initiator
    meeting_invitations.find_by(role: MeetingInvitation.role_initiator).user
  end

  def guests
    guest_invitations.map(&:user)
  end

  def invitation(user)
    meeting_invitations.find_by(user: user)
  end

  def started?
    guest_invitations.any? { |invitation| invitation.state == MeetingInvitation.state_accepted }
  end

  private

  def guest_invitations
    meeting_invitations.where(role: MeetingInvitation.role_guest)
  end
end
