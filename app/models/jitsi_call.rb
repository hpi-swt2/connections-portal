# A model for storing jitsi calls initiated from contacts++
class JitsiCall < ApplicationRecord
  validates :room_name, presence: true

  has_many :call_participants, dependent: :destroy
  has_many :users, through: :call_participants
end
