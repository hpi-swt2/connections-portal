require 'rails_helper'

RSpec.describe "Navbar", type: :feature do

  before do
    @user = FactoryBot.build(:user)
    sign_in @user

    visit root_path
  end

  describe "profile dropdown" do
    it "is not expanded by default" do

    end

    it "is expands after being clicked on" do

    end

    it "contains a link to the users profile page" do

    end

    it "contains a link to the users edit profile page" do

    end
  end

end
