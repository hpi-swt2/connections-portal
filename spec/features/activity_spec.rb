require 'rails_helper'

RSpec.describe 'Activities', driver: :selenium_headless, type: :feature, js: true do
  let(:user) { FactoryBot.create :user }

  before do
    sign_in user
    visit home_index_path
  end

  it 'a text box to commit activities' do
    expect(page).to have_field('activity-textarea')
  end

  it 'can be added on the dashboard' do
    fill_in 'activity-textarea', with: 'This is an activity'
    find('#add-activity-button').click
    sleep(0.5) # async
    expect(user.activities).to be_any { |activity| activity.content == 'This is an activity' }
  end

  it 'has an cleared text box after a successful submit' do
    fill_in 'activity-textarea', with: 'This is an activity'
    find('#add-activity-button').click
    expect(page).to have_field('activity-textarea', text: '')
  end
end
