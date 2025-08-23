require 'rails_helper'

RSpec.describe 'Api::V1::CartItems', type: :request do
  let!(:user) { create(:user, :with_cart) }
  let(:headers) { { 'Authorization' => "Bearer #{user.generate_jwt}" } }
  let!(:product) { create(:product) }

  describe 'Cart management' do
    it 'lists cart items' do
      create(:cart_item, cart: user.cart, product: product)
      get '/api/v1/cart_items', headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('data')
      expect(json_response).to have_key('status')
      expect(json_response['status']).to have_key('code')
      expect(json_response['status']).to have_key('message')
    end

    it 'adds item to cart' do
      post '/api/v1/cart_items', params: { cart_item: { product_id: product.id, quantity: 2 } }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('data')
      expect(json_response).to have_key('status')
      expect(json_response['status']).to have_key('message')
    end
  end
end
