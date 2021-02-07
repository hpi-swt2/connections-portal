require 'rails_helper'

RSpec.describe 'Avatar', type: :request do
  let(:user) { FactoryBot.create :user }

  describe 'POST upload' do
    let(:headers) { { ACCEPT: 'application/javascript' } }
    let(:path) { 'spec/support/assets/new-avatar.jpeg' }
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join(path), 'image/jpeg') }
    let(:params) { { avatar: { file: file } } }

    context 'when signed in' do
      it "changes the user's avatar" do
        sign_in user
        post upload_avatars_path, params: params, headers: headers
        user.reload
        expect(user.avatar.filename).to eq(file.original_filename)
      end
    end

    context 'when not signed in' do
      it 'sets the http status code to unauthorized' do
        post upload_avatars_path, params: params, headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET serve' do
    context 'when signed in' do
      it "returns the user's avatar" do
        sign_in user
        get serve_avatar_path(user.avatar)
        expect(response.body).to eq(user.avatar.file)
      end
    end

    context 'when not signed in' do
      it 'redirects to the login page' do
        get serve_avatar_path(user.avatar)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
