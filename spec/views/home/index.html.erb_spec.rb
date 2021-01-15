require 'rails_helper'

<<<<<<< HEAD
RSpec.describe "home/index", type: :view do
  before { render }

  it 'renders a login button' do
    expect(rendered).to have_link(I18n.t('navigation.log_in'), href: new_user_session_path)
  end

  it 'renders a signup button' do
    expect(rendered).to have_link(I18n.t('navigation.sign_up'), href: new_user_registration_path)
  end
end
