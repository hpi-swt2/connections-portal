require 'rails_helper'

RSpec.describe "contact_requests/index", type: :view do
  before(:each) do
    @user1 = FactoryBot.create :user
    @user2 = FactoryBot.create :user
    sign_in @user1
    assign(:requests, [@user2])
  end

  it 'renders contact requests' do
    render
    expect(rendered).to include(@user2.email)
  end
end
