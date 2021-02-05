require 'rails_helper'

RSpec.describe 'Jitsi Calls', driver: :selenium_headless, type: :feature, js: true do
  let!(:user1) { FactoryBot.create :user, current_status: User.status_nice_to_meet_you }
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

  context 'with two users' do
    before do
      Capybara.using_session(:user1) do
        sign_in user1
        visit root_path
      end

      Capybara.using_session(:user2) do
        sign_in user2
        visit root_path
      end
    end

    it 'a user can be called when in status "nice to meet you"' do

    end

    it 'a user can not be called when not in status "nice to meet you"' do

    end

    it 'a user receives a popup when another user calls them' do

    end

    it 'a user receives a popup while it calls another user' do

    end

    it 'a calling user receives a notification when the target denied the call' do
    end

    it 'a calling user gets redirected when the target accept the call' do
    end

    it 'a user receiving a call gets redirected when he accept the call' do
    end
  end
end
