require 'rails_helper'

RSpec.describe Room, type: :model do
  it 'exists with global chat' do
    expect(described_class.find(Room::GLOBAL_CHAT_ID)).not_to be_nil
  end
end
