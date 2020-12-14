require 'rails_helper'

RSpec.describe "Users", type: :feature do
  before(:each) do
    @user1 = FactoryBot.create :user
    @user2 = FactoryBot.create :user
    @user3 = FactoryBot.create :user
    sign_in @user1
    visit home_index_path
  end

  it "adds a contact when the button is clicked" do
    find_by(id: @user2.id.to_s).click_button

    expect(@user1.contacts).to include(@user2)
  end
end
