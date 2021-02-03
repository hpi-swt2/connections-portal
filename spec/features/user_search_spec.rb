require 'rails_helper'

describe 'Filter users by key', type: :feature do
  let(:user) { FactoryBot.create :user }

  before { sign_in user }

  describe 'without filter' do
    let!(:users) { FactoryBot.create_list(:user, 3) }
    let(:second_user) { FactoryBot.create :user }

    before { visit search_users_path }

    it 'is possible to filter by username' do
      visit search_users_path(search: second_user.username[0..2])
      # It is possible to search for the user via its user name but the user name it self is not displayed.
      expect(page).to have_text(second_user.firstname)
    end

    it 'shows all other users when no filter is given' do
      users.each { |user| expect(page).to have_text(user.email) }
    end

    it 'does not show myself' do
      expect(page).not_to have_text(user.email)
    end
  end

  describe 'with filter' do
    let!(:erika) { FactoryBot.create :user, :erika }
    let!(:maximilian) { FactoryBot.create :user, :maximilian }

    before { visit search_users_path(search: search) }

    context 'with part of firstname' do
      let(:search) { 'aximi' }

      it 'is possible to filter by firstname' do
        expect(page).to have_text(maximilian.email)
      end

      it 'does not show non-matching users when filtering by firstname' do
        expect(page).not_to have_text(erika.email)
      end
    end

    context 'with part of lastname' do
      let(:search) { 'erma' }

      it 'is possible to filter by lastname' do
        expect(page).to have_text(maximilian.email)
      end

      it 'does not show non-matching users when filtering by lastname' do
        expect(page).not_to have_text(erika.email)
      end
    end

    context 'with part of username' do
      let(:search) { 'erli' }

      it 'is possible to filter by username' do
        expect(page).to have_text(maximilian.email)
      end

      it 'does not show non-matching users when filtering by username' do
        expect(page).not_to have_text(erika.email)
      end
    end

    context 'with part of email' do
      let(:search) { 'est@exa' }

      it 'is possible to filter by email' do
        expect(page).to have_text(maximilian.email)
      end

      it 'does not show non-matching users when filtering by email' do
        expect(page).not_to have_text(erika.email)
      end
    end
  end
end
