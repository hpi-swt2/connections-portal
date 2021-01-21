require 'rails_helper'

RSpec.describe 'Users', type: :feature do
  before { visit new_user_registration_path }

  it 'can sign up' do
    within '#new_user' do
      user_attrs = FactoryBot.attributes_for(:user)
      fill_in 'Email', with: user_attrs[:email]
      fill_in 'Password', with: user_attrs[:password]
      fill_in 'Password confirmation', with: user_attrs[:password]
      find('input[type="submit"]').click
    end

    expect(page).to have_current_path root_path
    expect(page).to have_css('.alert-success', count: 1)
    # See config/locales/devise.en.yml
    expect(page).to have_content(I18n.t('devise.registrations.signed_up'))
  end

  it 'can not signup without matching passwords' do
    within '#new_user' do
      user_attrs = FactoryBot.attributes_for(:user)
      fill_in 'Email', with: user_attrs[:email]
      fill_in 'Password', with: user_attrs[:password]
      fill_in 'Password confirmation', with: 'wrong_password'
      find('input[type="submit"]').click
    end
    expect(page).to have_css('.alert-danger', count: 1)
    expect(page).to have_content(I18n.t('errors.messages.not_saved.one', resource: 'user'))
  end
end
