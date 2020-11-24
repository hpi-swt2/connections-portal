require 'rails_helper'

RSpec.describe "Users", type: :feature do
  it "can sign up" do 
    visit root_path
    
    within '#registration' do
      click_on "signup"
    end
    
    within '#new_user' do
      user_attrs = FactoryBot.attributes_for(:user)
      fill_in "Email", with: user_attrs[:email]
      fill_in "Password", with: user_attrs[:password]
      fill_in "Password confirmation", with: user_attrs[:password]
      find('input[type="submit"]').click
    end

    expect(page).to have_current_path root_path
    expect(page).to have_css(".alert-success", count: 1)
    # See config/locales/devise.en.yml
    expect(page).to have_content(I18n.t 'devise.registrations.signed_up')
  end
end
