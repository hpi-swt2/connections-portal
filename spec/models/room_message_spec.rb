require 'rails_helper'

RSpec.describe RoomMessage, type: :model do
  let(:room_message) { FactoryBot.build :room_message }

  it 'is creatable using a factory' do
    expect(room_message).to be_valid
  end

  it 'is invalid without a message' do
    room_message.message = ''
    expect(room_message).not_to be_valid
  end

  it 'json should contain the display name key' do
    room_message.save
    expect(room_message.as_json).to have_key :display_name
  end

  it 'json should have the correct display name' do
    room_message.save
    expect(room_message.as_json[:display_name]).to eq(room_message.user.display_name)
  end

  it 'formats time' do
    room_message.created_at = Time.utc(2021, 7, 8, 9, 10)
    expect(room_message.formatted_time).to eq '2021-07-08 09:10'
  end
end
