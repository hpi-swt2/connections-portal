require 'rails_helper'

RSpec.describe "Users profile page", driver: :selenium_headless, type: :feature do
  let(:user) { FactoryBot.create :user }

  before do
    user.social_accounts.create(social_network: "GitHub", user_name: "SomeGitUserName")
    user.save()
    user.social_accounts.create(social_network: "Telegram", user_name: "SomeTelegramUserName")
    user.save()
    sign_in user
end

it 'show social account' do
    visit edit_user_path(user)

    expect(page).to have_text("GitHub")
    expect(page).to have_text("SomeGitUserName")
    expect(page).to have_text("Telegram")
    expect(page).to have_text("SomeTelegramUserName")
  end

  it 'provides link to edit social account' do
    visit edit_user_path(user)
    find_link(href: "/users/#{user.id}/social_accounts/#{user.social_accounts[0].id}/edit").click
    # Checks that social account and user name are the default value of the input
    expect(page.find('#social_account_social_network').value).to eq "GitHub"
    expect(page.find('#social_account_user_name').value).to eq "SomeGitUserName"
  end

  it 'provides link to remove social account' do
    visit edit_user_path(user)  
    find_link("Remove", href: "/users/#{user.id}/social_accounts/#{user.social_accounts[1].id}").click
    page.should have_no_content("SomeTelegramUserName")
  end

  it 'provides link to social account website' do
    visit edit_user_path(user)
    expect(page).to have_link(href: "https://#{user.social_accounts[0].social_network.downcase}.com/#{user.social_accounts[0].user_name}")
  end

  it 'changes social account values' do
    visit edit_user_social_account_path(user, user.social_accounts[0])

    find('#social_account_user_name').set("SomeOtherGitUserName")
    find('input[type="submit"]').click
  
    expect(page).to_not have_text("SomeGitUserName")
    expect(page).to have_text("GitHub")
    expect(page).to have_text("SomeOtherGitUserName")
  end

  it 'shows error upon edit with invalid values' do
    visit edit_user_social_account_path(user, user.social_accounts[0])

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
