require 'rails_helper'

RSpec.describe 'Popup', type: :feature, driver: :selenium_headless, js: true do

  let(:user) { FactoryBot.create :user }

  before do
    sign_in user
    visit root_path
  end

  def open_popup(message = 'Test Message', timeout = -1)
    page.execute_script("generatePopup('#{message}', 'fa-refresh', [], #{timeout})")
  end

  def open_popup_buttons(message = 'Test Message', timeout = -1)
    page.execute_script("generatePopup('#{message}',
      'fa-refresh',
      [{'label': 'Accept', 'action' : ()=>$('body').append('<p>Popup test successful</p>')}],
      #{timeout})")
  end

  it 'is not shown' do
    expect(page).not_to have_css('.popup')
  end

  it 'is shown after opening' do
    open_popup
    expect(page).to have_css('.popup')
  end

  it 'contains given message' do
    message = 'A simple popup message'
    open_popup(message)
    within '.popup' do
      expect(page).to have_text(message)
    end
  end

  it 'contains no buttons' do
    open_popup
    within '.popup' do
      expect(page).not_to have_css('button')
    end
  end

  it 'contains buttons when created with buttons' do
    open_popup_buttons
    within '.popup' do
      expect(page).to have_css('button')
    end
  end

  it 'performs button action on click' do
    open_popup_buttons
    within '.popup' do
      click_button 'Accept'
    end
    expect(page).to have_text('Popup test successful')
  end

  it 'is hidden after button click' do
    open_popup_buttons
    within '.popup' do
      click_button 'Accept'
    end
    sleep(0.5) # Fade out takes 400ms
    expect(page).not_to have_css('.popup')
  end

end
