require 'rails_helper'

RSpec.describe "home/index", type: :view do

  context "user not signed in" do
    it "renders a login button" do
      render
      expect(rendered).to have_link(I18n.t('navigation.log_in'), :href => new_user_session_path)
    end

    it "renders a signup button" do
      render
      expect(rendered).to have_link(I18n.t('navigation.sign_up'), :href => new_user_registration_path)
    end
  end

  context "user signed in" do
    before(:each) do
      @users = assign(:users, FactoryBot.create_list(:user, 3))
      sign_in @users.first

      render
    end

    describe "users list" do
      it "shows the heading" do
        expect(rendered).to have_text(I18n.t('dashboard.user_list'))
      end

      it "renders a list of users" do
        @users.each do |user|
          expect(rendered).to match user.name
        end
      end

      it "has an + button to add a contact" do
        expect(rendered).to have_button('+', count: @users.length)
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
