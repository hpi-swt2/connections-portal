=begin
require 'rails_helper'

RSpec.describe 'Profile picture', type: :feature do

  let(:user) { FactoryBot.create :user }

  it 'is possible to upload a profile picture' do
    sign_in user
    visit edit_user_path(user)
    find('input[type="file_field"]').click
    # here we have to upload a normal picture e.g 'test_picture.png'
    expect(page).to have_text("test_picture.png")
  end

  it 'is not possible to upload a picture larger then 5 MB' do
    sign_in user
    visit edit_user_path(user)
    find('input[type="file_field"]').click
    # here we have to upload a picture larger 5 MB
    # something like that? attach_file 'Image', '/path/to/image.jpg'
    expect(page).to have_text("Avatar File size should be less than 5 MB")
  end

  it 'is only possible to upload pictures of type jpeg, jpg and png' do
    sign_in user
    visit edit_user_path(user)
    find('input[type="file_field"]').click
    # Here we have to upload a picture of non-valid type
    # something like that? attach_file 'Image', '/path/to/image.pdf'
    expect(page).to have_text("Avatar is not a valid file format")
  end

  it 'is a profile-picture shown on the user-show-page' do
    sign_in user
    visit user_path(user)
    expect(page).to have_selector('image_tag')
  end

  # todo: model and controller tests
end
=end

