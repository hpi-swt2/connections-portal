require 'rails_helper'

RSpec.describe "SocialAccounts", driver: :selenium_headless, type: :request do
  let(:user) { FactoryBot.create :user }

  before do
    sign_in user
  end

  describe "POST /users/:user_id/social_accounts" do
    context "with valid parameters" do
      it "creates a new social account" do
        post user_social_accounts_path(user), params: { social_account: { social_network: "GitHub", user_name: "Foo" } }
        expect(response).to redirect_to(edit_user_url(user))
        expect(user.social_accounts.count).to eq(1)
      end
    end
  end

  describe "POST /users/:user_id/social_accounts" do
    context "with not valid parameters" do
      it "creates a new social account" do
        post user_social_accounts_path(user), params: { social_account: { social_network: "", user_name: "" } }
        expect(response).to render_template("users/edit")
        expect(user.social_accounts.count).to eq(0)
      end
    end
  end

  describe "DELETE /users/:user_id/social_accounts/:id" do
    it "deletes a social account" do
      social_account = user.social_accounts.create(social_network: "Telegram", user_name: "foo")
      user.save
      delete user_social_account_path(user, social_account)
      expect(response).to have_http_status(:redirect)
      expect(user.social_accounts.count).to eq(0)
    end
  end
end
