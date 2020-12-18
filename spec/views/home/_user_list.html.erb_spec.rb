require 'rails_helper'

RSpec.describe "home/_user_list", type: :view do
  before { @users = assign(:users, FactoryBot.create_list(:user, 3)) }

  it "renders a list of users" do
    render
    @users.each do |user|
      expect(rendered).to match user.email
    end
  end

  it "has an + button to add a contact" do
    render
    expect(rendered).to have_button('+', count: @users.length)
  end
end
