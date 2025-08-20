class Api::V1::Admin::ProductsController < Api::V1::ApplicationController
  before_action :require_admin
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    products = Product.all.order(created_at: :desc)
    render json: {
      status: { code: 200, message: 'Products retrieved successfully.' },
      data: products.map { |product| product_serializer(product) }
    }
  end

  def show
    render json: {
      status: { code: 200, message: 'Product retrieved successfully.' },
      data: product_serializer(@product)
    }
  end

  def create
    product = Product.new(product_params)
    
    if product.save
      render json: {
        status: { code: 200, message: 'Product created successfully.' },
        data: product_serializer(product)
      }
    else
      render json: {
        status: { message: "Creation failed: #{product.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: {
        status: { code: 200, message: 'Product updated successfully.' },
        data: product_serializer(@product)
      }
    else
      render json: {
        status: { message: "Update failed: #{@product.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    render json: {
      status: { code: 200, message: 'Product deleted successfully.' }
    }
  end

  private

  def require_admin
    unless current_user.admin?
      render json: {
        status: { message: 'Access denied. Admin privileges required.' }
      }, status: :forbidden
    end
  end

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: 'Product not found.' }
    }, status: :not_found
  end

  def product_params
    params.require(:product).permit(:name, :category, :vegetarian, :price, :image)
  end

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
