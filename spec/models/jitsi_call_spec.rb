require 'rails_helper'

RSpec.describe JitsiCall, type: :model do
  let(:jitsi_call) { FactoryBot.create :jitsi_call }

  it 'is creatable using a factory' do
    expect(jitsi_call).to be_valid
  end

  it 'is invalid without a room name' do
    jitsi_call.room_name = ''
    expect(jitsi_call).not_to be_valid
  end

  context 'with invitations' do
    let(:guests) { FactoryBot.create_list :user, 2 }

    before do
      guests.each do |guest|
        jitsi_call.meeting_invitations.create(
          user: guest,
          state: MeetingInvitation.state_requested,
          role: MeetingInvitation.role_guest
        )
      end
    end

    it 'has associated users' do
      expect(jitsi_call.users).to include(*guests)
    end

    it 'has meeting invitations' do
      expect(jitsi_call.meeting_invitations.map(&:user_id)).to include(*guests.map(&:id))
    end

    it 'destroys all invitations when destroyed' do
      expect { jitsi_call.destroy }.to change(MeetingInvitation, :count).from(guests.size).to(0)
    end
  end
end
