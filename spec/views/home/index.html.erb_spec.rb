require 'rails_helper'

RSpec.describe "home/index", type: :view do

  it "renders a login button" do
    render
    expect(rendered).to have_link(I18n.t('navigation.log_in'), :href => new_user_session_path)
  end

  it "renders a signup button" do
    render
    expect(rendered).to have_link(I18n.t('navigation.sign_up'), :href => new_user_registration_path)
  end

end