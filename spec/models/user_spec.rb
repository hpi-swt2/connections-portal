require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build :user }
  let(:contact) { FactoryBot.create :user }
  let(:request) { FactoryBot.create :user }
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

  it 'has an empty contacts list' do
    expect(user.contacts).to be_empty
  end

  it 'has a contact after adding one' do
    contact = FactoryBot.build(:user)
    user.contacts << contact
    expect(user.contacts).to include(contact)
  end

  it 'has no relationship to social accounts' do
    user_with_no_social_accounts = FactoryBot.build(:user)
    expect(user_with_no_social_accounts.social_accounts).to be_empty
  end

  # rubocop:disable RSpec/MultipleExpectations

  it 'can have many social accounts' do
    user_with_social_accounts.social_accounts.create(social_network: 'GitHub', user_name: 'SomeGitUserName')
    user_with_social_accounts.social_accounts.create(social_network: 'Telegram', user_name: 'SomeTelegramUserName')

    expect(user_with_social_accounts.social_accounts[0].social_network).to eq('GitHub')
    expect(user_with_social_accounts.social_accounts[1].social_network).to eq('Telegram')
  end
  # rubocop:enable RSpec/MultipleExpectations

  describe 'contact requests' do
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
  # rubocop:disable RSpec/MultipleMemoizedHelpers

  describe 'status scope' do
    let(:user1) { FactoryBot.create :user, current_status: described_class.status_working }
    let(:user2) { FactoryBot.create :user, current_status: described_class.status_free_for_chat }

    it 'returns only users with the given status' do
      users = described_class.with_status(described_class.status_working)
      expect(users).to include(user1)
      expect(users).not_to include(user2)
    end
  end

  # rubocop:enable RSpec/MultipleMemoizedHelpers

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
end
