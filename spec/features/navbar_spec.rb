require 'rails_helper'

RSpec.describe 'Navbar', driver: :selenium_headless, type: :feature, js: true do

  before do
    @user = FactoryBot.create(:user)
    sign_in @user

    visit root_path
  end

  describe 'profile dropdown' do
    it 'is not expanded by default' do
      profile_dropdown = page.find('#navbarProfileDropdown + div', visible: :all)
      expect(profile_dropdown['class']).to_not include('show')
    end

    it 'expands after being clicked on' do
      toggle_profile_dropdown
      profile_dropdown = page.find('#navbarProfileDropdown + div')
      expect(profile_dropdown['class']).to include('show')
    end

    it 'contains a link to the users profile page' do
      toggle_profile_dropdown
      within '#navbarProfileDropdown + div' do
        expect(page).to have_link(href: user_path(@user))
      end
    end

    it 'contains a link to the users edit profile page' do
      toggle_profile_dropdown
      within '#navbarProfileDropdown + div' do
        expect(page).to have_link(href: edit_user_registration_path(@user))
      end
    end

    def toggle_profile_dropdown
      page.execute_script('document.getElementById("navbarProfileDropdown").click()')
    end
  end

end
