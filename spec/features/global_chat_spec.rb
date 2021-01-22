require 'rails_helper'

RSpec.describe 'Global Chat', driver: :selenium_headless, type: :feature, js: true do
  let(:user) { FactoryBot.create :user }
  let(:message) { "A message: #{('a'..'z').to_a.shuffle.join}" }

  before do
    sign_in user
    visit root_path
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

  it 'does not display my own display name' do
    within('#chat-messages') do
      expect(page).not_to have_text(user.display_name)
    end
    post_message(message)
    within('#chat-messages') do
      expect(page).not_to have_text(user.display_name)
    end
  end

  it 'shows the correct timestamp' do
    post_message(message)
    message = RoomMessage.all.last
    expect(page).to have_text(message.formatted_time)
  end

  def login(user)
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button('commit')
  end

  # Test web socket with multiple sessions
  # It seems like one can not use sign_in with multiple sessions
  it 'updates the messages' do
    user2 = FactoryBot.create :user
    Capybara.using_session(:one) do
      login(user)
      visit root_path
    end

    Capybara.using_session(:two) do
      login(user2)
      visit root_path
    end

    Capybara.using_session(:one) do
      post_message(message)
    end

    Capybara.using_session(:two) do
      within('#chat-messages') do
        expect(page).to have_text(user.display_name)
        expect(page).to have_text(message)
      end
    end
  end
end
