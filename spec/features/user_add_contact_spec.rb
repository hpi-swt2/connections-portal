require 'rails_helper'

RSpec.describe "Users", type: :feature do
  before(:each) do
    @user1 = FactoryBot.create :user
    @user2 = FactoryBot.create :user
    @user3 = FactoryBot.create :user
    sign_in @user1
    visit users_path
  end

  it "adds a contact when the button is clicked" do
    find_by_id(@user2.id.to_s).click

    expect(@user1.contacts).to include(@user2)
  end
end
