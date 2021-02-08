require 'rails_helper'

RSpec.describe 'User list', type: :feature do
  let(:user) { FactoryBot.create :user, current_status: User.filter_status.sample }
  let(:working_user) { FactoryBot.create :user, current_status: User.status_working }

  before { sign_in user }

  context 'with some users' do
    let!(:users) { FactoryBot.create_list :user, 3, current_status: User.filter_status.sample }

    before { visit root_path }

    it 'shows the right number of users' do
      expect(page).to have_css('div#filtered_user_list div.user-card', count: users.length)
    end

    it 'does not show the current user' do
      within('#filtered_user_list') do
        expect(page).not_to have_text(user.display_name)
      end
    end

    it 'does not show users with another status' do
      expect(page).not_to have_text(working_user.display_name)
    end
  end

  context 'when in working status' do
    let!(:available_user) { FactoryBot.create :user, current_status: User.filter_status.sample }

    before do
      user.current_status = User.status_working
      visit root_path
    end

    it 'does not show available user' do
      expect(page).not_to have_text(available_user.display_name)
    end

    it 'has busy text' do
      expect(page).to have_text(I18n.t('user.status.busy_text'))
    end
  end

  context 'with many users' do
    before do
      FactoryBot.create_list :user, 20, current_status: User.filter_status.sample
      visit root_path
    end

    it 'only shows 4 users' do
      expect(page).to have_css('div#filtered_user_list div.user-card', count: HomeController::MAXIMUM_LENGTH_USER_LIST)
    end

    it 'shows start to talk with... or maybe with...' do
      expect(page).to have_text(I18n.t('user.status.start_talk'))
      expect(page).to have_text(I18n.t('user.status.or_maybe'))
    end
  end
end
