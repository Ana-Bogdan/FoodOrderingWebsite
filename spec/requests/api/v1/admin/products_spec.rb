require 'rails_helper'

RSpec.describe 'Api::V1::Admin::Products', type: :request do
  let!(:admin_user) { create(:user, :admin) }
  let!(:regular_user) { create(:user) }
  let(:admin_headers) { { 'Authorization' => "Bearer #{admin_user.generate_jwt}" } }
  let(:regular_headers) { { 'Authorization' => "Bearer #{regular_user.generate_jwt}" } }

  describe 'Admin access control' do
    it 'allows admin to access products' do
      get '/api/v1/admin/products', headers: admin_headers
      
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('data')
      expect(json_response).to have_key('status')
      expect(json_response['status']).to have_key('message')
    end

    it 'blocks regular user from admin area' do
      get '/api/v1/admin/products', headers: regular_headers
      
      expect(response).to have_http_status(:forbidden)
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('status')
      expect(json_response['status']).to have_key('message')
    end
  end
end
