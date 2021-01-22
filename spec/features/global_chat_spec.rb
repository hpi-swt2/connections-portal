require 'rails_helper'

RSpec.describe 'Global Chat', driver: :selenium_headless, type: :feature, js: true do
  let(:user) { FactoryBot.create :user }
  let(:message) { 'A message' }

  before do
    sign_in user
    visit root_path
  end

  def in_browser(name)
    old_session = Capybara.session_name
    Capybara.session_name = name
    yield
    Capybara.session_name = old_session
  end

  def post_message(message)
    fill_in 'room_message_message', with: message
    find('#post-chat-button').click
  end

  it 'clears text box after message submit' do
    post_message(message)
    expect(page).to have_field('room_message_message', text: '')
  end

  it 'displays the new message' do
    expect(page).not_to have_text(message)
    post_message(message)
    expect(page).to have_text(message)
  end

  it 'shows the correct timestamp' do
    post_message(message)
    message = RoomMessage.all.last
    expect(page).to have_text(message.formatted_time)
  end

  it 'updates the messages' do
    user2 = FactoryBot.create :user
    in_browser(:one) do
      sign_in user
      visit root_path
    end

    in_browser(:two) do
      sign_in user2
      visit root_path
    end

    in_browser(:one) do
      post_message(message)
    end

    in_browser(:two) do
      expect(page).to have_text(message)
    end
  end
end
