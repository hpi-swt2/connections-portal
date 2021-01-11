require 'rails_helper'

RSpec.describe "Dashboard", driver: :selenium_headless, type: :feature, js: true do
  let(:user) { FactoryBot.create :user }

  before do
    sign_in user
    visit root_path
  end

  it 'has a dropdown to select status' do
    expect(page).to have_select('user[current_status]')
  end
  # Behavior of status dropdown is tested in user_profile_spec.rb
end
