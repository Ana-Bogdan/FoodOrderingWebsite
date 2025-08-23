class Api::V1::ProductsController < Api::V1::ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  api :GET, "/api/v1/products", "List all products" if defined?(Apipie)
  def index
    products = Product.all
    render json: {
      status: { code: 200, message: "Products retrieved successfully." },
      data: ProductSerializer.new(products).serializable_hash
    }
  end

  api :GET, "/api/v1/products/:id", "Get specific product" if defined?(Apipie)
  def show
    product = Product.find(params[:id])
    render json: {
      status: { code: 200, message: "Product retrieved successfully." },
      data: ProductSerializer.new(product).serializable_hash
    }
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: "Product not found." }
    }, status: :not_found
  end
end
