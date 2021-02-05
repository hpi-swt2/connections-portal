require 'rails_helper'

RSpec.describe MeetingInvitation, type: :model do
  let(:invitation) { FactoryBot.build :meeting_invitation }

  it 'is creatable using a factory' do
    expect(invitation).to be_valid
  end

  it 'is invalid with an unknown state' do
    invitation.state = 'test'
    expect(invitation).not_to be_valid
  end

  it 'is invalid with an unknown role' do
    invitation.role = 'test'
    expect(invitation).not_to be_valid
  end
end
