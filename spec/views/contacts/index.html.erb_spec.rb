require 'rails_helper'

RSpec.describe "contacts/index", type: :view do
  before(:each) do
    @user1 = FactoryBot.create :user
    @user2 = FactoryBot.create :user
    sign_in @user1
    @user1.contacts << @user2
  end

  it "show an added contact" do
    render
    expect(rendered).to have_text @user2.email
  end
end
