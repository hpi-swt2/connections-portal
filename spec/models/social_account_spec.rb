require 'rails_helper'

RSpec.describe SocialAccount, type: :model do
  let(:social_account) { FactoryBot.create :social_account }

  it 'is creatable using a factory' do
    expect(social_account).to be_valid
  end

  it 'is not valid without a social network' do
    social_account.social_network = ''
    expect(social_account).not_to be_valid
  end

  it 'is not valid without a user name' do
    social_account.user_name = ''
    expect(social_account).not_to be_valid
  end
end
