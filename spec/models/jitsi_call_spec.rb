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

  context 'with participants' do
    let(:participants) { FactoryBot.create_list :user, 2 }

    before do
      participants.each do |participant|
        jitsi_call.call_participants.create(
          user: participant,
          state: CallParticipant::VALID_STATES[0],
          role: CallParticipant::VALID_ROLES[0]
        )
      end
    end

    it 'has associated users' do
      expect(jitsi_call.users).to include(*participants)
    end

    it 'has call participants' do
      expect(jitsi_call.call_participants.map(&:user_id)).to include(*participants.map(&:id))
    end

    it 'destroys all participants when destroyed' do
      expect { jitsi_call.destroy }.to change(CallParticipant, :count).from(participants.size).to(0)
    end
  end
end
