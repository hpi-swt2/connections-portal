require 'rails_helper'

RSpec.describe "Dashboard", driver: :selenium_headless, type: :feature, js: true do
  let(:user) { FactoryBot.create :user }

  before do
    sign_in user
    visit root_path
  end

  it 'has a dropdown to select status' do
    expect(page).to have_select('user[current_status]')
  end

  it 'can change status by selecting item in status dropdown' do
    user.update(current_status: 'working')
    target_status = 'free_for_chat'
    page.execute_script('document.getElementById("user_current_status").querySelector("option[value=\"' +
                          target_status + '\"]").selected = true')
    # required since we change the node programmatically
    page.execute_script('document.getElementById("user_current_status").onchange()')
    sleep(0.1) # required, as we need to wait for the post request to be sent and processed
    user.reload
    expect(user.current_status).to eq(target_status)
  end
end
