require 'rails_helper'

RSpec.describe "Users profile page", driver: :selenium_headless, type: :feature do
  let(:user) { FactoryBot.create :user }
  let(:social_account1) { FactoryBot.create :social_account }
  let(:social_account2) { FactoryBot.create :social_account }

  before do
    user.social_accounts.push(social_account1)
    user.social_accounts.push(social_account2)
    user.save()
    sign_in user
end

it 'show social account' do
    visit edit_user_path(user)

    expect(page).to have_text(social_account1.social_network)
    expect(page).to have_text(social_account1.user_name)
    expect(page).to have_text(social_account2.social_network)
    expect(page).to have_text(social_account2.user_name)
  end

  it 'provides link to edit social account' do
    visit edit_user_path(user)
    find_link(href: edit_user_social_account_path(user, social_account1.id)).click
    # Checks that social account and user name are the default value of the input
    expect(page.find('#social_account_social_network').value).to eq social_account1.social_network
    expect(page.find('#social_account_user_name').value).to eq social_account1.user_name
  end

  it 'provides link to remove social account' do
    visit edit_user_path(user)  
    user_social_account_path(user, social_account1.id)
    find_link("Remove", href: user_social_account_path(user, social_account1.id)).click
    page.should have_no_content(social_account1.user_name)
  end

  it 'provides link to social account website' do
    visit edit_user_path(user)
    expect(page).to have_link(href: "https://#{social_account1.social_network.downcase}.com/#{social_account1.user_name}")
  end

  it 'changes social account values' do
    visit edit_user_social_account_path(user, social_account1.id)

    find('#social_account_user_name').set("SomeOtherUserName")
    find('input[type="submit"]').click
  
    expect(page).to_not have_text(social_account1.user_name)
    expect(page).to have_text(social_account1.social_network)
    expect(page).to have_text("SomeOtherUserName")
  end

  it 'shows error upon edit with invalid values' do
    visit edit_user_social_account_path(user, social_account1.id)

    find('#social_account_user_name').set("")
    find('input[type="submit"]').click

    expect(page).to have_text("can't be blank")
  end

  it 'can add social account' do
    visit edit_user_path(user)

    find('#social_account_user_name').set("IAmForBusiness")
    find_button((I18n.t 'user.edit.add_social_account_label')).click

    expect(page).to have_text("GitHub")
    expect(page).to have_text("IAmForBusiness")
  end

  it 'shows error upon addition with invalid values' do
    visit edit_user_path(user)

    find('#social_account_user_name').set("")
    find_button((I18n.t 'user.edit.add_social_account_label')).click

    expect(page).to have_text("can't be blank")
  end
end
