require 'rails_helper'

RSpec.describe "Application", type: :request do

  it 'renders a 404 if active record model is not found' do
    get '/users/-1'
    expect(response).to have_http_status :not_found
  end
end
