require 'rails_helper'

describe "Notes", type: :feature do
  before(:each) do
    @alice = FactoryBot.create(:user)
    @bob = FactoryBot.create(:user)
    @new_note = FactoryBot.build(:note)
    assert @alice.save
    assert @bob.save
  end

  # TODO: Split up
  it "can create a new note" do
    sign_in @alice
    visit new_note_path
    fill_in "Title", with: @new_note.title
    fill_in "Content", with: @new_note.content
    fill_in "User", with: @bob.id
    click_button "Create Note"

    visit notes_path
    expect(page).to have_text(@new_note.title)
    expect(page).to have_text(@new_note.content)
    expect(page).to have_text(@bob.id)
  end

  it "shows just the notes created by the user" do
    @another_note = FactoryBot.create(:note, creator_user: @alice)
    sign_in @alice
    #note is shown when alice is logged in
    visit notes_path
    expect(page).to have_text(@another_note.title)
    sign_out @alice
    # note isn't shown when bob is logged in
    sign_in @bob
    visit notes_path
    expect(page).not_to have_text(@another_note.title)
  end

end
