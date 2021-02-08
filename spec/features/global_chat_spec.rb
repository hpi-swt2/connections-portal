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

  context 'with a posted message' do
    let(:room_message) { RoomMessage.all.last }
    before do
      post_message(message)
      room_message
    end

    it 'clears text box after message submit' do
      expect(page).to have_field('room_message_message', text: '')
    end

    it 'shows the correct timestamp' do
      expect(page).to have_text(room_message.formatted_time)
    end

    it "displays the user's avatar" do
      expect(page).to have_css("img[src='#{avatar_user_path(user)}']")
    end

    it 'shows the correct timestamp after reload' do
      visit root_path
      expect(page).to have_text(room_message.formatted_time)
    end
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
    using_session(:one) do
      login(user)
      visit root_path
    end

    using_session(:two) do
      login(user2)
      visit root_path
    end

    using_session(:one) do
      post_message(message)
    end

    using_session(:two) do
      within('#chat-messages') do
        expect(page).to have_text(user.display_name)
        expect(page).to have_text(message)
      end
    end
  end
end
