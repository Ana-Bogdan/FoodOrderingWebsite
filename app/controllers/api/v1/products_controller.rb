class Api::V1::ProductsController < Api::V1::ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    products = Product.all
    render json: {
      status: { code: 200, message: "Products retrieved successfully." },
      data: products.map { |product| product_serializer(product) }
    }
  end

  def show
    product = Product.find(params[:id])
    render json: {
      status: { code: 200, message: "Product retrieved successfully." },
      data: product_serializer(product)
    }
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: "Product not found." }
    }, status: :not_found
  end

  private

  def product_serializer(product)
    {
      id: product.id,
      name: product.name,
      category: product.category,
      vegetarian: product.vegetarian,
      price: product.price,
      image: product.image,
      created_at: product.created_at,
      updated_at: product.updated_at
    }
  end
end
