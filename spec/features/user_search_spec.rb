require 'rails_helper'

describe 'Filter users by key', type: :feature do
  let(:user) { FactoryBot.create :user }
  let(:second_user) { FactoryBot.create :user }

  before do
    sign_in user
  end

  it 'is possible to filter by firstname' do
    visit users_search_path(search: second_user.firstname[0..2])
    expect(page).to have_text(second_user.firstname)
  end

  it 'is possible to filter by lastname' do
    visit users_search_path(search: second_user.lastname[2..4])
    expect(page).to have_text(second_user.lastname)
  end

  it 'is possible to filter by username' do
    visit users_search_path(search: second_user.username[0..2])
    expect(page).to have_text(second_user.username)
  end

  it 'is possible to filter by email' do
    visit users_search_path(search: second_user.email[0..2])
    expect(page).to have_text(second_user.email)
  end

  it 'does not show non-matching users when filtering by firstname' do
    visit users_search_path(search: user.firstname[0..2])
    expect(page).not_to have_text(second_user.firstname)
  end

  it 'does not show non-matching users when filtering by lastname' do
    visit users_search_path(search: user.lastname[0..2])
    expect(page).not_to have_text(second_user.lastname)
  end

  it 'does not show non-matching users when filtering by username' do
    visit users_search_path(search: user.username[0..2])
    expect(page).not_to have_text(second_user.username)
  end

  it 'does not show non-matching users when filtering by email' do
    visit users_search_path(search: user.email[0..2])
    expect(page).not_to have_text(second_user.email[0..2])
  end
end
