require 'rails_helper'

RSpec.describe "SocialAccounts", driver: :selenium_headless, type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/social_accounts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/:user_id/social_accounts/new" do
    it "returns http success" do
      user = FactoryBot.build(:user)
      user.save
      sign_in user
      get "/users/#{user.id}/social_accounts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users/:user_id/social_accounts" do
    context "with valid parameters" do
      it "creates a new social account" do
        user = FactoryBot.build(:user)
        user.save
        sign_in user
        post "/users/#{user.id}/social_accounts", params: { social_account: { social_network: "GitHub", user_name: "Foo" } }
        expect(response).to redirect_to(edit_user_url(user))
        expect(user.social_accounts.count).to eq(1)
      end
    end
  end

  describe "POST /users/:user_id/social_accounts" do
    context "with not valid parameters" do
      it "creates a new social account" do
        user = FactoryBot.build(:user)
        user.save
        sign_in user
        post "/users/#{user.id}/social_accounts", params: { social_account: { social_network: "", user_name: "" } }
        expect(response).to render_template("users/edit")
        expect(user.social_accounts.count).to eq(0)
      end
    end
  end

  describe "DELETE /users/:user_id/social_accounts/:id" do
    it "deletes a social account" do
      user = FactoryBot.build(:user)
      user.save
      social_account = user.social_accounts.create(social_network: "Telegram", user_name: "foo")
      user.save
      sign_in user
      delete "/users/#{user.id}/social_accounts/#{social_account.id}"
      expect(response).to have_http_status(:redirect)
      expect(user.social_accounts.count).to eq(0)
    end
  end
end
