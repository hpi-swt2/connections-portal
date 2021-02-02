require 'rails_helper'

RSpec.describe 'Profile picture', type: :feature do

  let(:user) { FactoryBot.create :user }
  let(:contact) { FactoryBot.create :user }


  it 'is possible to upload a profile picture' do
    sign_in user
    visit edit_user_path(user)
    attach_file 'user_avatar', 'spec/support/assets/new-avatar.jpeg'
    click_button 'Update User'
    visit user_path(user)
    expect(page).to have_css("img[src*='new-avatar.jpeg']")
  end

  it 'is not possible to upload a picture larger then 5 MB' do
    sign_in user
    visit edit_user_path(user)
    attach_file 'user_avatar', 'spec/support/assets/avatar-big.jpeg'
    click_button 'Update User'
    expect(page).to have_text('Avatar File size should be less than 5 MB')
  end

  it 'is only possible to upload pictures' do
    sign_in user
    visit edit_user_path(user)
    attach_file 'user_avatar', 'spec/support/assets/avatar.mp4'
    click_button 'Update User'
    expect(page).to have_text('Avatar is not a valid file format')
  end

  it 'is a profile-picture shown on the user-show-page' do
    sign_in user
    visit user_path(user)
    expect(page).to have_css("img[src*='avatar-default-test.png']")
  end

  it 'is a profile-picture shown on the my-contacts-page' do
    sign_in user
    user.contacts << contact
    visit user_contacts_path(user)
    expect(page).to have_css("img[src*='avatar-default-test.png']")
  end
end
