require 'rails_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  let!(:products) { create_list(:product, 3) }
  let!(:product) { products.first }

  describe 'Product listing' do
    it 'returns all products' do
      get '/api/v1/products'

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('data')
      expect(json_response).to have_key('status')
      expect(json_response['status']).to have_key('message')
    end

    it 'returns specific product' do
      get "/api/v1/products/#{product.id}"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('data')
      expect(json_response).to have_key('status')
      expect(json_response['status']).to have_key('message')
    end
  end
end
