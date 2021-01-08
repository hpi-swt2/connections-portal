require 'rails_helper'

RSpec.describe "User filtering", type: :feature, js: true, driver: :selenium_headless do
  before do
    FactoryBot.create_list :user, 4, current_status: 'working'
    FactoryBot.create :user, current_status: 'free_for_chat'
    sign_in FactoryBot.create(:user, current_status: 'working')
  end

  describe "filtered by status" do
    before do
      visit root_path
      page.execute_script(
        "document.getElementById(\"filter_status\").querySelector(\"option[value=#{search_status}]\").selected = true"
      )
      # required since we change the node programmatically
      page.execute_script('document.getElementById("filter_status").onchange()')
    end

    context "with an unique status" do
      let(:search_status) { 'free_for_chat' }

      it "does show exactly one user" do
        expect(page).to have_css("div#filtered_user_list div.user-list-item", count: 1)
      end

      it "has still selected the status after the page reload" do
        expect(page).to have_css "select#filter_status option[value=#{search_status}][selected=selected]"
      end
    end

    context "with a frequent status" do
      let(:search_status) { 'working' }

      it "shows all five users" do
        expect(page).to have_css("div#filtered_user_list div.user-list-item", count: 5)
      end

      it "has still selected the status after the page reload" do
        expect(page).to have_css "select#filter_status option[value=#{search_status}][selected=selected]"
      end
    end
  end

  describe "with invalid status" do
    before { visit "/?filter_status=invalid" }

    it "uses the default option 'free_for_chat'" do
      expect(page).to have_css("div#filtered_user_list div.user-list-item", count: 1)
    end

    it "shows the default option 'free_for_chat'" do
      expect(page).to have_css "select#filter_status option[value=free_for_chat][selected=selected]"
    end
  end

  describe "without filtering" do
    before { visit root_path }

    it "uses the default option 'free_for_chat'" do
      expect(page).to have_css("div#filtered_user_list div.user-list-item", count: 1)
    end

    it "shows the default option 'free_for_chat'" do
      expect(page).to have_css "select#filter_status option[value=free_for_chat][selected=selected]"
    end
  end
end
