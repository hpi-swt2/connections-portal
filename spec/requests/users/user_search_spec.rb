require 'rails_helper'

RSpec.describe "Search users", type: :request do
  before { sign_in FactoryBot.create(:user) }

  it "rerenders the user list" do
    get root_path, params: { filter_status: 'available' }
    expect(response).to render_template('home/_users')
  end
end
