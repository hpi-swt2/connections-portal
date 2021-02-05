require 'rails_helper'

RSpec.describe 'users/search', type: :view do
  let(:users) { FactoryBot.create_list(:user, 3) }

  before do
    assign(:users, users)
    assign(:users_to_add, users)
    sign_in users.first
    render
  end

  it 'renders a list of users before searching' do
    users.each do |user|
      expect(rendered).to match user.email
    end
  end

  it 'has a search form to look for contacts' do
    expect(rendered).to have_css('form[action="/users/search"]')
  end
end
