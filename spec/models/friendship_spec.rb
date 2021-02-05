require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:users) { FactoryBot.create_list :user, 3 }

  before { described_class.create(user_id: users[0].id, contact_id: users[1].id) }

  it 'creates a symmetrical association' do
    expect(described_class.find_by(user_id: users[0].id, contact_id: users[1].id)).to be_present
    expect(described_class.find_by(user_id: users[1].id, contact_id: users[0].id)).to be_present
  end

  it 'deletes both parts of the association' do
    described_class.find_by(user_id: users[0].id, contact_id: users[1].id).destroy!
    expect(described_class.find_by(user_id: users[0].id, contact_id: users[1].id)).to be_blank
    expect(described_class.find_by(user_id: users[1].id, contact_id: users[0].id)).to be_blank
  end

  describe 'multiple contacts' do
    before { described_class.create(user_id: users[0].id, contact_id: users[2].id) }

    it 'allows a user to have multiple contacts' do
      expect(described_class.find_by(user_id: users[0].id, contact_id: users[1].id)).to be_present
      expect(described_class.find_by(user_id: users[0].id, contact_id: users[2].id)).to be_present
    end

    it 'allows to only delete one of the contacts' do
      described_class.find_by(user_id: users[0].id, contact_id: users[1].id).destroy!
      expect(described_class.find_by(user_id: users[0].id, contact_id: users[1].id)).to be_blank
      expect(described_class.find_by(user_id: users[0].id, contact_id: users[2].id)).to be_present
    end
  end
end
