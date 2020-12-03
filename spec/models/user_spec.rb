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
    expect(@user.contactlist).to be_empty
  end

  it "should have a contact after adding one" do
    contact = FactoryBot.build(:user)
    @user.contactlist.add(contact)
    expect(@user.contactlist).to include(contact)
  end
end
