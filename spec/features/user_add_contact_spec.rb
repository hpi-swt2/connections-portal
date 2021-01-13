require 'rails_helper'

RSpec.describe "Users", type: :feature do
  before(:each) do
    @requesting_user = FactoryBot.create :user
    @requested_user = FactoryBot.create :user
  end

  it "adds a contact request when the button is clicked" do
    sign_in @requesting_user
    visit users_path
    find("form[action='#{user_contact_requests_path(@requested_user)}']").find("input").click
    expect(@requested_user.contact_requests).to_not be_empty
    expect(@requested_user.contact_requests).to include(@requesting_user)
  end

  it "adds a contact when the button is clicked" do
    find_by_id(@user2.id.to_s).click_button

    expect(@user1.contacts).to include(@user2)
  end
end
