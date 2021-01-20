require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  let(:users) { FactoryBot.create_list(:user, 3) }
  let(:signed_in_user) { FactoryBot.create(:user) }

  before do
    assign(:users, users)
    sign_in signed_in_user
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

    it 'has a + button to send contact request' do
      expect(rendered).to have_button('+', count: users.length)
    end

    it 'does have a + button for not requested user' do
      expect(rendered).to have_css("form.button_to[action=\"/users/#{users.second.id}/contact_requests\"]")
    end

    it 'is not possible to see myself in the list of all users' do
      expect(rendered).not_to have_text(signed_in_user, count: users.length)
    end
  end

  it 'does not have a + button for already requested user' do
    users.second.contact_requests << signed_in_user
    users_to_send_requests_to(signed_in_user)
    render
    expect(rendered).not_to have_css("form.button_to[action=\"/users/#{users.second.id}/contact_requests\"]")
  end

  it 'does not have a + button for already existing contacts' do
    signed_in_user.contacts << users.second
    users_to_send_requests_to(signed_in_user)
    render
    expect(rendered).to have_css("form.button_to[action=\"/users/#{users.first.id}/contact_requests\"]")
    expect(rendered).not_to have_css("form.button_to[action=\"/users/#{users.second.id}/contact_requests\"]")
  end

  def users_to_send_requests_to(current_user)
    users_to_add = users.reject do |user|
      current_user.sent_contact_request?(user)
    end
    assign(:users_to_add, users_to_add)
  end
end
