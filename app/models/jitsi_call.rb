# A model for storing jitsi calls initiated from contacts++
class JitsiCall < ApplicationRecord
  validates :room_name, presence: true

  has_many :call_participants, dependent: :delete_all, inverse_of: :jitsi_call
  has_many :users, through: :call_participants

  BASE_URL = 'https://jitsi.giz.berlin'.freeze

  def url
    "#{BASE_URL}/#{room_name}"
  end

  def initiator
    call_participants.find_by(role: 'initiator')
  end

  def guests
    call_participants.where(role: 'guest')
  end
end
