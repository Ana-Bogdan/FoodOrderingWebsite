require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  describe 'Authentication' do
    it 'registers new user' do
      post '/api/v1/register', params: {
        user: { name: 'Test User', email: 'test@example.com', password: 'password123', password_confirmation: 'password123' }
      }
      expect(response).to have_http_status(:ok)
    end

    it 'logs in user' do
      user = create(:user)
      post '/api/v1/login', params: { user: { email: user.email, password: 'password123' } }
      expect(response).to have_http_status(:ok)
    end

    it 'logs out user' do
      user = create(:user)
      headers = { 'Authorization' => "Bearer #{user.generate_jwt}" }
      delete '/api/v1/logout', headers: headers
      expect(response).to have_http_status(:ok)
    end
  end
end
