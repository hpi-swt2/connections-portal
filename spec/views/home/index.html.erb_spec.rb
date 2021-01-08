require 'rails_helper'

RSpec.describe "home/index", type: :view do
  before(:each) do
    @users = assign(:users, FactoryBot.create_list(:user, 3))
    sign_in @users.first
  end

  it "renders a list of users" do
    render
    @users.each do |user|
      expect(rendered).to match user.email
    end
  end

  it "has an + button to add a contact except for one" do
    render
    expect(rendered).to have_button('+', count: (@users.length - 1))
  end

  it "should not be possible to see myself in the list of all users" do
    render
    expect(rendered).to_not have_text(@users.first.email, count: 2)
  end
end
