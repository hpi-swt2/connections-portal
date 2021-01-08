require 'rails_helper'

RSpec.describe "Users profile page", driver: :selenium_headless, js:true, type: :feature do
  let(:user) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }

  before do
    sign_in user
    visit user_path(user)
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

  it 'status is editable when showing current user' do
    expect(page).to have_select('user[current_status]')
  end

  it 'status is not editable when showing different user' do
    visit user_path(user2)
    expect(page).not_to have_select('user[current_status]')
  end

  it 'contains the "free for chat" status' do
    expect(page).to have_select('user[current_status]', with_options: ['free for chat'])
  end

  it 'shows current status when showing different user' do
    user2.current_status = "available"
    user2.save
    visit user_path(user2)
    expect(page).to have_text(I18n.t('user.status.available'))
  end
end
