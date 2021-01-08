require 'rails_helper'

RSpec.describe "Users profile page", type: :feature do
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
    page.find(:css, 'a[href="/users/1/social_accounts/1/edit"]').click

    expect(find_field("Social network").value).to eq "GitHub"
    expect(find_field("User name").value).to eq "SomeGitUserName"
  end

  it 'provides link to remove social account' do
    visit edit_user_path(user)
    
    # TODO(): we should specifically access the link which makes an delete request
    page.find(:css, 'a[href="/users/1/social_accounts/2"]').click

    expect(find_field("Social network").value).not_to eq "Telegram"
    expect(find_field("User name").value).not_to eq "SomeTelegramUserName"
  end

  it 'changes social account values' do
    visit edit_user_social_account_path(user, user.social_accounts[0])

    fill_in "Social network", with: "Git+Hub"
    fill_in "User name", with: "SomeOtherGitUserName"
    find('input[type="submit"]').click

    expect(page).to_not have_text("GitHub")
    expect(page).to_not have_text("SomeGitUserName")
    expect(page).to have_text("Git+Hub")
    expect(page).to have_text("SomeOtherGitUserName")
  end

  it 'shows error upon edit with invalid values' do
    visit edit_user_social_account_path(user, user.social_accounts[0])

    fill_in "Social network", with: ""
    fill_in "User name", with: ""
    find('input[type="submit"]').click

    expect(page).to have_text("can't be blank")
  end

  it 'can add social account' do
    visit edit_user_path(user)

    fill_in "Social network", with: "LinkedIn"
    fill_in "User name", with: "IAmForBusiness"
    find_button("Create Social Account").click

    expect(page).to have_text("LinkedIn")
    expect(page).to have_text("IAmForBusiness")
  end

  it 'shows error upon addition with invalid values' do
    visit edit_user_path(user)

    fill_in "Social network", with: ""
    fill_in "User name", with: ""
    find_button("Create Social Account").click

    expect(page).to have_text("can't be blank")
  end
end
