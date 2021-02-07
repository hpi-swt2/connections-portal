require 'rails_helper'

RSpec.describe 'Profile picture', driver: :selenium_headless, type: :feature, js: true do
  let(:user) { FactoryBot.create :user }
  let(:contact) { FactoryBot.create :user }

  before { sign_in user }

  it "shows a profile picture on the user's show page" do
    visit user_path(user)
    expect(page).to have_css("img[src='#{serve_avatar_path(user.avatar)}']")
  end

  it "shows a profile picture on the user's edit profile page" do
    visit edit_profile_user_path(user)
    expect(page).to have_css("img[src='#{serve_avatar_path(user.avatar)}']")
  end

  context "when visiting the user's contacts page" do
    let!(:contacts) { FactoryBot.create_list :user, 3 }

    before { contacts.each { |contact| user.contacts << contact } }

    it 'shows a profile picture for all contacts' do
      visit user_contacts_path(user)
      contacts.each do |contact|
        expect(page).to have_css("img[src='#{serve_avatar_path(contact.avatar)}']")
      end
    end
  end

  context 'when visiting the user search page' do
    let!(:users) { FactoryBot.create_list :user, 3 }

    it 'shows profile pictures for all users' do
      visit search_users_path
      users.each do |user|
        expect(page).to have_css("img[src='#{serve_avatar_path(user.avatar)}']")
      end
    end
  end

  it 'is possible to upload a profile picture' do
    visit edit_profile_user_path(user)
    upload_avatar 'spec/support/assets/new-avatar.jpeg'
    user.reload
    expect(user.avatar.filename).to eq('new-avatar.jpeg')
  end

  it 'is not possible to upload an invalid profile picture' do
    visit edit_profile_user_path(user)
    upload_avatar 'spec/support/assets/avatar-big.jpeg'
    expect(page).to have_text('File size must be less than or equal to 5242880')
  end

  private

  def upload_avatar(path)
    attach_file 'avatar_file', path
    within '#new_avatar' do
      click_button 'commit'
    end
  end
end
