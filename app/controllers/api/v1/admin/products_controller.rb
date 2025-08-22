class Api::V1::Admin::ProductsController < Api::V1::ApplicationController
  include AdminAuthenticatable
  
  before_action :require_admin
  before_action :set_product, only: [ :show, :update, :destroy ]

  api :GET, "/api/v1/admin/products", "List all products (admin)" if defined?(Apipie)
  def index
    products = Product.all.order(created_at: :desc)
    render json: {
      status: { code: 200, message: "Products retrieved successfully." },
      data: ProductSerializer.new(products).serializable_hash
    }
  end

  api :GET, "/api/v1/admin/products/:id", "Get specific product (admin)" if defined?(Apipie)
  def show
    render json: {
      status: { code: 200, message: "Product retrieved successfully." },
      data: ProductSerializer.new(@product).serializable_hash
    }
  end

  api :POST, "/api/v1/admin/products", "Create new product (admin)" if defined?(Apipie)
  def create
    product = Product.new(product_params)

    if product.save
      render json: {
        status: { code: 200, message: "Product created successfully." },
        data: ProductSerializer.new(product).serializable_hash
      }
    else
      render json: {
        status: { message: "Creation failed: #{product.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  end

  api :PATCH, "/api/v1/admin/products/:id", "Update product (admin)" if defined?(Apipie)
  def update
    if @product.update(product_params)
      render json: {
        status: { code: 200, message: "Product updated successfully." },
        data: ProductSerializer.new(@product).serializable_hash
      }
    else
      render json: {
        status: { message: "Update failed: #{@product.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  end

  api :DELETE, "/api/v1/admin/products/:id", "Delete product (admin)" if defined?(Apipie)
  def destroy
    @product.destroy
    render json: {
      status: { code: 200, message: "Product deleted successfully." }
    }
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: "Product not found." }
    }, status: :not_found
  end

  def product_params
    params.require(:product).permit(:name, :category, :vegetarian, :price, :image)
  end
end
