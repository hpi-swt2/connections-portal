require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build :user }
  let(:user_with_social_accounts) { FactoryBot.create :user }

  it 'is creatable using a factory' do
    expect(user).to be_valid
  end

  it 'is invalid with an unknown status' do
    user.current_status = 'unavailable'
    expect(user).not_to be_valid
  end

  it 'is not valid with an email without @' do
    user.email = 'testATexample.de'
    expect(user).not_to be_valid
  end

  it 'is not valid without an email' do
    user.email = ''
    expect(user).not_to be_valid
  end

  it 'is not valid without a password' do
    user.password = ''
    user.password_confirmation = ''
    expect(user).not_to be_valid
  end

  it 'is not valid without a username' do
    user.username = ''
    expect(user).not_to be_valid
  end

  it 'creates user name from email' do
    user = FactoryBot.create(:user_without_username, email: 'test-user@example.org')
    expect(user.username).to eq('test-user')
  end

  it 'creates user with default status available' do
    user = described_class.new({ email: 'test-user@example.org' })
    expect(user.current_status).to eq(described_class.status_available)
  end

  it 'has no relationship to social accounts' do
    user_with_no_social_accounts = FactoryBot.build(:user)
    expect(user_with_no_social_accounts.social_accounts).to be_empty
  end

  it 'can have many social accounts' do
    user_with_social_accounts.social_accounts.create(social_network: 'GitHub', user_name: 'SomeGitUserName')
    user_with_social_accounts.social_accounts.create(social_network: 'Telegram', user_name: 'SomeTelegramUserName')

    expect(user_with_social_accounts.social_accounts[0].social_network).to eq('GitHub')
    expect(user_with_social_accounts.social_accounts[1].social_network).to eq('Telegram')
  end

  describe 'contacts' do
    let(:contact) { FactoryBot.create :user }

    it 'has an empty contacts list' do
      expect(user.contacts).to be_empty
    end

    it 'has a contact after adding one' do
      contact = FactoryBot.build(:user)
      user.contacts << contact
      expect(user.contacts).to include(contact)
    end
  end

  describe 'contact requests' do
    let(:contact) { FactoryBot.create :user }
    let(:request) { FactoryBot.create :user }

    it 'adds user to contact request list of other user' do
      contact.contact_requests << user
      expect(contact.contact_requests).to include(user)
      expect(contact.contacts).not_to include(user)
    end

    it 'adds and deletes contact request' do
      contact.contact_requests << user
      expect(contact.contact_requests).to include(user)
      contact.contact_requests.delete(user)
      expect(contact.contact_requests).not_to include(user)
    end

    it 'has different contact and request lists' do
      user.contacts << contact
      user.contact_requests << request
      expect(user.contact_requests).to include(request)
      expect(user.contact_requests).not_to include(contact)
    end

    it 'determines other users which the user has send a contact request to' do
      expect(user.sent_contact_request?(request)).to be false
      request.contact_requests << user
      expect(user.sent_contact_request?(request)).to be true
    end

    it 'determines other users which are in my contacts' do
      expect(user.sent_contact_request?(contact)).to be false
      user.contacts << contact
      expect(user.sent_contact_request?(contact)).to be true
    end
  end

  describe 'status scope' do
    let(:user1) { FactoryBot.create :user, current_status: described_class.status_working }
    let(:user2) { FactoryBot.create :user, current_status: described_class.status_free_for_chat }

    it 'returns only users with the given status' do
      users = described_class.with_status(described_class.status_working)
      expect(users).to include(user1)
      expect(users).not_to include(user2)
    end
  end

  describe 'display name' do
    it 'contains the first and last name if present' do
      user = FactoryBot.build(:user, firstname: 'Hasso', lastname: 'Plattner', username: 'hasso01')
      expect(user.display_name).to eq('Hasso Plattner')
    end

    it 'contains the last name if present' do
      user = FactoryBot.build(:user, firstname: '', lastname: 'Plattner', username: 'hasso01')
      expect(user.display_name).to eq('Plattner')
    end

    it 'contains the first name if present' do
      user = FactoryBot.build(:user, firstname: 'Hasso', lastname: '', username: 'hasso01')
      expect(user.display_name).to eq('Hasso')
    end

    it 'contains the username if neither first nor lastname are present' do
      user = FactoryBot.build(:user, firstname: '', lastname: '', username: 'hasso01')
      expect(user.display_name).to eq('hasso01')
    end
  end

  context 'with jitsi calls' do
    let(:jitsi_calls) { FactoryBot.create_list :jitsi_call, 2 }

    before do
      user.save
      jitsi_calls.each do |call|
        user.meeting_invitations.create(
          jitsi_call: call,
          state: MeetingInvitation.state_requested,
          role: MeetingInvitation.role_guest
        )
      end
    end

    it 'has associated jitsi calls' do
      expect(user.jitsi_calls).to include(*jitsi_calls)
    end

    it 'has meeting invitations' do
      expect(user.meeting_invitations.map(&:jitsi_call_id)).to include(*jitsi_calls.map(&:id))
    end

    it 'destroys all invitations when destroyed' do
      expect { user.destroy }.to change(MeetingInvitation, :count).from(jitsi_calls.size).to(0)
    end
  end

  context 'with contacts' do
    let(:contacts) { FactoryBot.create_list :user, 2 }

    before do
      user.save
      contacts.each { |contact| user.friendships.create(contact: contact) }
    end

    it 'has associated contacts' do
      expect(user.contacts).to include(*contacts)
    end

    it 'has friendships' do
      expect(user.friendships.map(&:contact_id)).to include(*contacts.map(&:id))
    end

    it 'destroys all friendships when destroyed' do
      user.destroy
      expect(Friendship.where(user_id: user.id)).to be_empty
      expect(Friendship.where(contact_id: user.id)).to be_empty
    end
  end

  it 'has a default profile picture' do
    expect { user.save }.to change(Avatar, :count).by(1)
    expect(user.avatar.file).to be_present
  end
end
