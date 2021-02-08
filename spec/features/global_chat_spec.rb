require 'rails_helper'

RSpec.describe 'Global Chat', driver: :selenium_headless, type: :feature, js: true do
  let(:user) { FactoryBot.create :user }
  let(:message_text) { "A message: #{('a'..'z').to_a.shuffle.join}" }

  before do
    sign_in user
    visit root_path
  end

  def post_message(message)
    fill_in 'room_message_message', with: message
    find('#post-chat-button').click
  end

  it 'displays the new message' do
    expect(page).not_to have_text(message_text)
    post_message(message_text)
    expect(page).to have_text(message_text)
  end

  it 'does not display my own display name' do
    within('#chat-messages') do
      expect(page).not_to have_text(user.display_name)
    end
    post_message(message_text)
    within('#chat-messages') do
      expect(page).not_to have_text(user.display_name)
    end
  end

  context 'with one posted message' do
    let(:message) { RoomMessage.all.last }

    before do
      post_message(message_text)
      message
    end

    it 'clears text box after message submit' do
      expect(page).to have_field('room_message_message', text: '')
    end

    it 'shows the correct timestamp' do
      within('#chat-messages') do
        expect(page).to have_text(message.formatted_time)
      end
    end

    it 'has a link to the users profile page in their avatar' do
      within('#chat-messages .chat-item .avatar-container') do
        expect(page).to have_link(href: user_path(user))
      end
    end

    it "displays the user's avatar" do
      within('#chat-messages') do
        expect(page).to have_css("img[src='#{avatar_user_path(user)}']")
      end
    end

    it 'shows the correct timestamp after reload' do
      visit root_path
      within('#chat-messages') do
        expect(page).to have_text(message.formatted_time)
      end
    end
  end

  def login(user)
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button('commit')
  end

  context 'with two users and a post' do
    # It seems like one can not use sign_in with multiple sessions
    let(:user2) { FactoryBot.create :user }

    before do
      using_session(:one) do
        login(user)
        visit root_path
      end
      using_session(:two) do
        login(user2)
        visit root_path
      end
      using_session(:one) do
        post_message(message_text)
      end
    end

    it 'receives the messages' do
      using_session(:two) do
        within('#chat-messages') do
          expect(page).to have_text(user.display_name)
          expect(page).to have_text(message_text)
        end
      end
    end

    it "has a link to the user's profile in the username" do
      using_session(:two) do
        within('#chat-messages .chat-item .chat-content') do
          expect(page).to have_link(user.display_name, href: user_path(user))
        end
      end
    end

    it "has a link to the user's profile in the avatar" do
      using_session(:two) do
        within('#chat-messages .chat-item .avatar-container') do
          expect(page).to have_link(href: user_path(user))
        end
      end
    end
  end
end
