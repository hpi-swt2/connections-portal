require 'rails_helper'

describe "Filter users by firstname", type: :feature do

     before(:each) do
        @user1 = User.new(firstname:"Max", lastname:"Mustermann", username:"Maxi", email: "example@example.com")
        @user2 = User.new(firstname:"Grace", lastname:"Hopper", username:"Profi", email: "demo@demo.com")
        sign_in @user1
      end

    it "When users visit the user search page, then it should be possible to filter by firstname" do
        visit users_search_path(firstname: "Ma")
        expect(page).to have_text("Max Mustermann")
        expect(page).not_to have_text("Grace")
    end

    it "When users visit the user search page, then it should be possible to filter by lastname" do
       visit users_search_path(lastname: "mann")
       expect(page).to have_text("Max Mustermann")
       expect(page).not_to have_text("Grace")
    end

    it "When users visit the user search page, then it should be possible to filter by username" do
        visit users_search_path(user: "Ma")
        expect(page).to have_text("Max Mustermann")
        expect(page).not_to have_text("Grace")
    end

    it "When users visit the user search page, then it should be possible to filter by email" do
        visit users_search_path(email: "example")
        expect(page).to have_text("Max Mustermann")
        expect(page).not_to have_text("Grace")
    end
end