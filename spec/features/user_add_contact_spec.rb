require 'rails_helper'

RSpec.describe "Users", type: :feature do
  before(:each) do
    @requesting_user = FactoryBot.create :user
    @requested_user = FactoryBot.create :user
  end

  it "adds a contact request when the button is clicked" do
    sign_in @requesting_user
    visit home_index_path
    find_by(id: @requested_user.id.to_s).click_button
    expect(@requested_user.contact_requests).to include(@requesting_user)
  end

  it 'is possible to accept a contact request' do
    sign_in @requested_user
    @requested_user.contact_requests << @requesting_user
    visit user_contact_requests_path(@requested_user)
    click_button("✓")
    expect(page).to_not have_text(@requesting_user.email)
    expect(@requesting_user.contacts).to include(@requested_user)
  end

  it 'is possible to deny a contact request' do
    sign_in @requested_user
    @requested_user.contact_requests << @requesting_user
    visit user_contact_requests_path(@requested_user)
    click_button("❌")
    expect(page).to_not have_text(@requesting_user.email)
    expect(@requesting_user.contacts).to_not include(@requested_user)
    expect(@requested_user.contact_requests).to_not include(@requesting_user)
  end
end
