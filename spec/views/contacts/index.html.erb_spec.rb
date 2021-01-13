require 'rails_helper'

RSpec.describe "contacts/index", type: :view do
  let(:user) { FactoryBot.create :user }

  before do
    sign_in FactoryBot.create(:user)
    assign(:contacts, [user])
  end

  it "show an added contact" do
    render
    expect(rendered).to have_text user.email
  end
end
