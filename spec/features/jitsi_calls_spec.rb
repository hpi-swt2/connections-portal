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
    let(:initiator_invitation) { call.meeting_invitations.find_by(user: user1) }
    let(:guest_invitation) { call.meeting_invitations.find_by(user: user2) }

    before do
      within("#init-call-#{user2.id}") do
        click_button('button')
      end
    end

    it 'has the correct invitations' do
      expect(call.meeting_invitations.map(&:user_id)).to include(user1.id)
      expect(call.meeting_invitations.map(&:user_id)).to include(user2.id)
      expect(call.meeting_invitations.count).to eq 2
    end

    it 'the initiator has the initiator role' do
      expect(initiator_invitation.role).to eq MeetingInvitation.role_initiator
    end

    it 'the invited user has the participant role' do
      expect(guest_invitation.role).to eq MeetingInvitation.role_guest
    end

    it 'the state of the initiator is accepted' do
      expect(initiator_invitation.state).to eq MeetingInvitation.state_accepted
    end

    it 'the state of the participant is requested' do
      expect(guest_invitation.state).to eq MeetingInvitation.state_requested
    end
  end
end
