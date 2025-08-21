require 'rails_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  let!(:products) { create_list(:product, 3) }
  let!(:product) { products.first }

  describe 'Product listing' do
    it 'returns all products' do
      get '/api/v1/products'
      expect(response).to have_http_status(:ok)
    end

    it 'returns specific product' do
      get "/api/v1/products/#{product.id}"
      expect(response).to have_http_status(:ok)
    end
  end
end
