require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = FactoryBot.build(:user)
  end

  it "is creatable using a factory" do
    expect(@user).to be_valid
  end

  it "is not valid with an email without @" do
    @user.email = "testATexample.de"
    expect(@user).not_to be_valid
  end

  it "is not valid without an email" do
    @user.email = ""
    expect(@user).to_not be_valid
  end

  it "is not valid without a password" do
    @user.password = ""
    @user.password_confirmation = ""
    expect(@user).not_to be_valid
  end

  it "is not valid without a username" do
    @user.username = ""
    expect(@user).not_to be_valid
  end
end
