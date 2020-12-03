require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    @users = assign(:users, FactoryBot.create_list(:user, 3))
  end

  it "renders a list of users" do
    render
    @users.each do |user|
      expect(rendered).to match user.email
    end
  end

  it "has an + button to add a contact" do
    render
    expect(rendered).to have_text('+', count: @users.length)
  end
end
