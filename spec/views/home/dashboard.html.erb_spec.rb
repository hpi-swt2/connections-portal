require 'rails_helper'

RSpec.describe "home/dashboard", type: :view do
  context "when signed in" do
    before(:each) do
      users = assign(:users, FactoryBot.create_list(:user, 3))
      assign(:status_filter, User.default_status_filter)
      sign_in users.first

      render
    end

    describe "users list" do
      it "shows the heading" do
        expect(rendered).to have_text(I18n.t('dashboard.user_list'))
      end

      it "has a status filter" do
        expect(rendered).to have_css "div#search_status_dropdown form[method=get][action=\"#{root_path}\"]"
        expect(rendered).to have_select('filter_status')
      end

      it "selects 'free for chat' by default" do
        expect(rendered).to have_css "select#filter_status option[value=free_for_chat][selected=selected]"
      end

      it "does not include 'offline'" do
        expect(rendered).not_to have_css "select#filter_status option[value=offline]"
      end
    end

    describe "global chat" do
      it "shows the heading" do
        expect(rendered).to have_text(I18n.t('dashboard.global_chat'))
      end
    end

    describe "last activities" do
      it "shows the heading" do
        expect(rendered).to have_text(I18n.t('dashboard.last_activities'))
      end
    end

    describe 'current proposals' do
      it "shows the heading" do
        expect(rendered).to have_text(I18n.t('dashboard.current_proposals'))
      end
    end
  end
end
