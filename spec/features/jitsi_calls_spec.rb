require 'rails_helper'

RSpec.describe 'Jitsi Calls', driver: :selenium_headless, type: :feature, js: true do
  let!(:user) { FactoryBot.create :user }
  let!(:participant) { FactoryBot.create :user, current_status: User.status_nice_to_meet_you }

  before do
    sign_in user
    visit root_path
  end

  it 'creates call when clicking on button' do
    within("#init-call-#{participant.id}") do
      click_button('button')
      new_call = user.jitsi_calls.first
      expect(new_call.call_participants.map(&:user_id)).to include(user.id)
      expect(new_call.call_participants.map(&:user_id)).to include(participant.id)
    end
  end
end
