require 'rails_helper'

RSpec.describe 'Api::V1::Orders', type: :request do
  let!(:user) { create(:user, :with_cart) }
  let(:headers) { { 'Authorization' => "Bearer #{user.generate_jwt}" } }
  let!(:product) { create(:product) }
  let!(:order) { create(:order, :with_items, user: user) }

  describe 'Order management' do
    it 'allows cancelling pending order' do
      patch "/api/v1/orders/#{order.id}/cancel", headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('data')
      expect(json_response).to have_key('status')
      expect(json_response['status']).to have_key('message')
    end

    it 'reorders from previous order' do
      post "/api/v1/orders/#{order.id}/reorder", headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('data')
      expect(json_response).to have_key('status')
      expect(json_response['status']).to have_key('message')
    end
  end
end
