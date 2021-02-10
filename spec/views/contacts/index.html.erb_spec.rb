require 'rails_helper'

RSpec.describe 'contacts/index', type: :view do
  let(:user) { FactoryBot.create :user }
  let(:social_account) { FactoryBot.create :social_account, social_network: 'GitHub', user_name: 'sample_name' }

  before do
    user.social_accounts << social_account
    sign_in FactoryBot.create(:user)
    assign(:contacts, [user])
    render
  end

  it 'shows an added contact' do
    expect(rendered).to have_text user.email
    expect(rendered).to have_text user.name
  end
end
