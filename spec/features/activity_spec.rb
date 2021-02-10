require 'rails_helper'

RSpec.describe 'Activities', driver: :selenium_headless, type: :feature, js: true do
  let(:user) { FactoryBot.create :user }

  before do
    sign_in user
    visit root_path
  end

  xit 'can be added in a text area' do
    expect(page).to have_field('activity-textarea')
  end

  xit 'can be added on the dashboard' do
    fill_in 'activity-textarea', with: 'This is an activity'
    find('#add-activity-button').click
    expect(user.activities.map(&:content)).to include('This is an activity')
  end

  xit 'has a cleared text box after a successful submit' do
    fill_in 'activity-textarea', with: 'This is an activity'
    find('#add-activity-button').click
    expect(page).to have_field('activity-textarea', text: '')
  end
end
