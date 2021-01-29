require 'rails_helper'

RSpec.describe 'users/search', type: :view do
  let(:users) { FactoryBot.create_list(:user, 3) }
  let(:contacts) { FactoryBot.create_list(:user, 3) }
  let(:user1) { FactoryBot.create :user }

  before do
    assign(:contacts, contacts)
    assign(:users, users)
    sign_in user1
    render
  end

  it 'renders a list of contacts' do
    contacts.each do |contact|
      expect(rendered).to match contact.email
    end
  end

  it 'renders a list of users' do
    users.each do |user|
      expect(rendered).to match user.email
    end
  end

  it 'has a search form to look for contacts' do
    expect(rendered).to have_css('form[action="/users/search"]')
  end
end
