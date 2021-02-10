require 'rails_helper'

RSpec.describe 'users/show.html.erb', type: :view do
  let(:user) { FactoryBot.create :user }

  before do
    assign(:user, user)
    render
  end

  it 'renders' do
  end

  describe 'profile information' do
    it 'shows the email' do
      expect(rendered).to have_text(user.email)
    end

    it 'shows the username' do
      expect(rendered).to have_text(user.username)
    end

    it 'shows the firstname' do
      expect(rendered).to have_text(user.firstname)
    end

    it 'shows the lastname' do
      expect(rendered).to have_text(user.lastname)
    end

    it 'shows place of residence' do
      expect(rendered).to have_text(user.place_of_residence)
    end

    it 'shows the birthdate' do
      expect(rendered).to have_text(user.birthdate)
    end

    it 'shows the current status' do
      expect(rendered).to have_text(user.current_status)
    end
  end
end
