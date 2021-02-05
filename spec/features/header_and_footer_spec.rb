require 'rails_helper'

RSpec.describe 'Header and Footer', driver: :selenium_headless, type: :feature, js: true do
  describe 'public page without being logged in' do
    before do
      visit root_path
    end

    it 'does not contain a link to the notes page' do
      expect(page).not_to have_link(href: notes_path)
    end

    it 'does not contain a link to the users page' do
      expect(page).not_to have_link(href: users_path)
    end

    it 'does not contain a link to the contacts page' do
      expect(page).not_to have_link('My contacts')
    end
  end

  describe 'notification' do
    let(:alice) { FactoryBot.create :user }
    let(:bob) { FactoryBot.create :user }

    before do
      alice.contact_requests << bob # bob added a contact request for alice
      sign_in alice
      visit notes_path
    end

    it 'shows the number of notifications in the navbar' do
      element = page.find('nav.navbar')
      expect(element).to have_text '1'
    end
  end
end
