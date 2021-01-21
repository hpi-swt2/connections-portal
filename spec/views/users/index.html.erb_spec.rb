require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  let(:users) { FactoryBot.create_list(:user, 5) }
  let(:users_to_add) { users[0..2]}
  let(:signed_in_user) { FactoryBot.create(:user) }

  before do
    assign(:users, users)
    assign(:users_to_add, users_to_add)
    sign_in signed_in_user
    render
  end

  it 'renders a list of users' do
    users.each do |user|
      expect(rendered).to match user.email
    end
  end

  it 'does have a + button for users in `users_to_add`' do
    users_to_add.each do |user|
      expect(rendered).to have_css("form.button_to[action=\"/users/#{user.id}/contact_requests\"]")
    end
  end


  it 'does not have a + button for users not in `users_to_add`' do
    (users - users_to_add).each do |user|
      expect(rendered).not_to have_css("form.button_to[action=\"/users/#{user.id}/contact_requests\"]")
    end
  end
end
