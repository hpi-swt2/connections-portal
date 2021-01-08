require 'rails_helper'

RSpec.describe 'Activities', driver: :selenium_headless, type: :feature, js: true do
  let(:user) { FactoryBot.create :user }

  before do
    sign_in user
    visit home_index_path
  end

  it 'can be added in a text area' do
    expect(page).to have_field('activity-textarea')
  end

  it 'can be added on the dashboard' do
    fill_in 'activity-textarea', with: 'This is an activity'
    find('#add-activity-button').click
    expect(user.activities.map(&:content)).to include('This is an activity')
  end

  it 'has an cleared text box after a successful submit' do
    fill_in 'activity-textarea', with: 'This is an activity'
    find('#add-activity-button').click
    expect(page).to have_field('activity-textarea', text: '')
  end
end
