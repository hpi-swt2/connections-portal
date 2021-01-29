require 'rails_helper'

RSpec.describe 'Jitsi Calls', driver: :selenium_headless, type: :feature, js: true do
  let!(:user1) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, current_status: User.status_nice_to_meet_you }

  before do
    sign_in user1
    visit root_path
  end

  context 'when a call is created' do
    let(:call) { user1.jitsi_calls.first }
    let(:initiator) { call.call_participants.where(user: user1).first }
    let(:participant) { call.call_participants.where(user: user2).first }

    before do
      within("#init-call-#{user2.id}") do
        click_button('button')
      end
    end

    it 'has the correct participants' do
      expect(call.call_participants.map(&:user_id)).to include(user1.id)
      expect(call.call_participants.map(&:user_id)).to include(user2.id)
      expect(call.call_participants.count).to eq 2
    end

    it 'the initiator has the initiator role' do
      expect(initiator.role).to eq 'initiator'
    end

    it 'the invited user has the participant role' do
      expect(participant.role).to eq 'participant'
    end

    it 'the state of the initiator is accepted' do
      expect(initiator.state).to eq 'accepted'
    end

    it 'the state of the participant is requested' do
      expect(participant.state).to eq 'requested'
    end
  end
end
