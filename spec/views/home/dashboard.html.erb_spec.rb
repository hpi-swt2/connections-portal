require 'rails_helper'

RSpec.describe 'home/dashboard', type: :view do
  let(:users) { FactoryBot.create_list :user, 3, current_status: User.filter_status }
  let(:room_messages) { FactoryBot.create_list :room_message, 3, room: Room.global_chat_room }

  before do
    assign(:users, users)
    assign(:room_messages, room_messages)
  end

  context 'when user is signed in' do
    before do
      sign_in users.first
      render
    end

    describe 'users list' do
      it 'shows the heading' do
        expect(rendered).to have_text(I18n.t('dashboard.user_list'))
      end

      it 'has a select for the current status' do
        expect(rendered).to have_css('select#user_current_status')
      end

      it 'shows the display names of the users' do
        users.each do |user|
          expect(rendered).to have_text(user.display_name)
        end
      end
    end

    describe 'global chat' do
      it 'shows the heading' do
        expect(rendered).to have_text(I18n.t('dashboard.global_chat'))
      end
    end

    describe 'last activities' do
      xit 'shows the heading' do
        expect(rendered).to have_text(I18n.t('dashboard.last_activities'))
      end
    end

    describe 'current proposals' do
      xit 'shows the heading' do
        expect(rendered).to have_text(I18n.t('dashboard.current_proposals'))
      end
    end
  end
end
