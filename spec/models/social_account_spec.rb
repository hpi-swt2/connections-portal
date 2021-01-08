require 'rails_helper'

RSpec.describe SocialAccount, type: :model do
  before(:each) do
    @social_account = FactoryBot.build(:social_account)
  end

  it "is creatable using a factory" do
    expect(@social_account).to be_valid
  end

  it "is not valid without a social network" do
    @social_account.social_network = ""
    expect(@social_account).to_not be_valid
  end

  it "is not valid without a user name" do
    @social_account.user_name = ""
    expect(@social_account).to_not be_valid
  end
end
