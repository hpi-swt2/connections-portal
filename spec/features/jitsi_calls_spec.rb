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

  context 'when th guest is not nice to meet you' do
    let(:initiator_invitation) { call.meeting_invitations.find_by(user: user1) }
    let(:guest_invitation) { call.meeting_invitations.find_by(user: user2) }

    it 'a call is not created' do
      user2.current_status = User.status_working
      user2.save
      expect do
        within("#init-call-#{user2.id}") do
          click_button('button')
        end
      end.not_to change { user2.jitsi_calls.count }
    end
  end

  def login(user)
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button('commit')
  end

  context 'with two users' do
    def start_call
      using_session(:user1) do
        within("#init-call-#{user2.id}") do
          click_button('button')
        end
      end
    end

    before do
      using_session(:user1) do
        login(user1)
        visit root_path
      end

      using_session(:user2) do
        login(user2)
        visit root_path
      end
    end

    it 'guest and initiator get popups during dialing' do
      start_call
      using_session(:user1) do
        within('.popup') do
          expect(page).to have_text(I18n.t('call.waiting'))
        end
      end
      using_session(:user2) do
        within('.popup') do
          expect(page).to have_text(I18n.t('call.notification_incoming_call', initiator: user1.display_name))
        end
      end
    end

    it 'a calling user receives a notification when the target denied the call' do
      start_call
      using_session(:user2) do
        within('.popup') do
          click_button(I18n.t('call.reject'))
        end
      end
      using_session(:user1) do
        within('.popup') do
          expect(page).to have_text(I18n.t('call.rejected', guest: user2.display_name))
        end
      end
    end

    it 'a calling user gets redirected when the target accepts the call' do
      start_call
      Capybara.using_session(:user2) do
        within('.popup') do
          click_button(I18n.t('call.accept'))
        end
      end
      using_session(:user1) do
        jitsi = Capybara.current_session.windows[1]
        Capybara.current_session.switch_to_window(jitsi)
        sleep(2)
        expect(Capybara.current_session.current_url).to start_with(JitsiCall::BASE_URL)
      end
    end

    it 'a user receiving a call gets redirected when the target accepts the call' do
      start_call
      using_session(:user2) do
        jitsi = window_opened_by do
          within('.popup') do
            click_button(I18n.t('call.accept'))
          end
        end
        Capybara.current_session.switch_to_window(jitsi)
        sleep(2)
        expect(Capybara.current_session.current_url).to start_with(JitsiCall::BASE_URL)
      end
    end

    it 'a caller can cancel the call' do
      start_call
      using_session(:user1) do
        within('.popup') do
          click_button(I18n.t('call.abort'))
        end
      end
      using_session(:user2) do
        within('.popup') do
          expect(page).to have_text(I18n.t('call.aborted', initiator: user1.display_name))
        end
      end
    end
  end
end
