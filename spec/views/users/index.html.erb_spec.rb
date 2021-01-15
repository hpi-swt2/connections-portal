require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  let(:users) { FactoryBot.create_list(:user, 3) }

  before do
    assign(:users, users)
    sign_in users.first
  end

  context 'with a user that has no contacts and no contact requests sent yet' do
    before do
      assign(:users_to_add, users)
      render
    end

    it 'renders a list of users' do
      users.each do |user|
        expect(rendered).to match user.email
      end
    end

    it 'has an + button to send contact request' do
      expect(rendered).to have_button('+', count: users.length)
    end

    it 'does have a + button for not requested user' do
      expect(rendered).to have_css("form.button_to[action=\"/users/#{users.second.id}/contact_requests\"]")
    end
  end

  it 'does not have a + button for already requested user' do
    users.second.contact_requests << users.first
    users_to_send_requests_to(users.first)
    render
    expect(rendered).not_to have_css("form.button_to[action=\"/users/#{users.second.id}/contact_requests\"]")
  end

  it 'does not have a + button for already existing contacts' do
    users.first.contacts << users.second
    users_to_send_requests_to(users.first)
    render
    expect(rendered).not_to have_css("form.button_to[action=\"/users/#{users.second.id}/contact_requests\"]")
  end

  def users_to_send_requests_to(current_user)
    users_to_add = users.reject do |user|
      current_user.sent_contact_request?(user)
    end
    assign(:users_to_add, users_to_add)
  end
end
