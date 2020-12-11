require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = FactoryBot.build(:user)
  end

  it "is creatable using a factory" do
    expect(@user).to be_valid
  end

  it "is not valid without an email" do
    @user.email = ""
    expect(@user).to_not be_valid
  end

  it "is not valid without a password" do
    @user.password = ""
    expect(@user).not_to be_valid
  end

  it "should have an empty contacts list" do
    expect(@user.contacts).to be_empty
  end

  it "should have a contact after adding one" do
    contact = FactoryBot.build(:user)
    @user.contacts << contact
    expect(@user.contacts).to include(contact)
  end

  it "should have no relationship to social accounts" do
      expect(@user.social_accounts).to be_empty
  end
end
