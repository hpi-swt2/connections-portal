require 'rails_helper'

RSpec.describe CallParticipant, type: :model do
  let(:participant) { FactoryBot.build :call_participant }

  it 'is creatable using a factory' do
    expect(participant).to be_valid
  end

  it 'is invalid with an unknown state' do
    participant.state = 'test'
    expect(participant).not_to be_valid
  end

  it 'is invalid with an unknown role' do
    participant.role = 'test'
    expect(participant).not_to be_valid
  end
end
