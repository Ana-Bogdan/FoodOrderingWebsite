require 'rails_helper'

RSpec.describe 'Api::V1::Admin::Orders', type: :request do
  let!(:admin_user) { create(:user, :admin) }
  let!(:regular_user) { create(:user) }
  let(:admin_headers) { { 'Authorization' => "Bearer #{admin_user.generate_jwt}" } }
  let(:regular_headers) { { 'Authorization' => "Bearer #{regular_user.generate_jwt}" } }

  describe 'Admin order management' do
    let!(:order) { create(:order, :with_items) }

    it 'allows admin to view orders' do
      get '/api/v1/admin/orders', headers: admin_headers

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('data')
      expect(json_response).to have_key('status')
      expect(json_response['status']).to have_key('message')
    end

    it 'allows admin to update order status' do
      patch "/api/v1/admin/orders/#{order.id}/update_status",
            params: { order: { status: 'completed' } },
            headers: admin_headers

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('data')
      expect(json_response).to have_key('status')
      expect(json_response['status']).to have_key('message')
    end
  end
end
