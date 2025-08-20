class Api::V1::CartItemsController < Api::V1::ApplicationController
  before_action :ensure_user_cart_exists

  def index
    cart_items = current_user.cart.cart_items.includes(:product)
    render json: {
      status: { code: 200, message: 'Cart items retrieved successfully.' },
      data: cart_items.map { |item| cart_item_serializer(item) }
    }
  end

  def create
    product = Product.find(params[:cart_item][:product_id])
    cart_item = current_user.cart.cart_items.find_by(product: product)

    if cart_item
      cart_item.update(quantity: cart_item.quantity + params[:cart_item][:quantity].to_i)
    else
      cart_item = current_user.cart.cart_items.create(
        product: product,
        quantity: params[:cart_item][:quantity]
      )
    end

    render json: {
      status: { code: 200, message: 'Item added to cart successfully.' },
      data: cart_item_serializer(cart_item)
    }
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: 'Product not found.' }
    }, status: :not_found
  end

  def update
    cart_item = current_user.cart.cart_items.find(params[:id])
    
    if cart_item.update(cart_item_params)
      render json: {
        status: { code: 200, message: 'Cart item updated successfully.' },
        data: cart_item_serializer(cart_item)
      }
    else
      render json: {
        status: { message: "Update failed: #{cart_item.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: 'Cart item not found.' }
    }, status: :not_found
  end

  def destroy
    cart_item = current_user.cart.cart_items.find(params[:id])
    cart_item.destroy

    render json: {
      status: { code: 200, message: 'Item removed from cart successfully.' }
    }
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: 'Cart item not found.' }
    }, status: :not_found
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end

  def ensure_user_cart_exists
    current_user.build_cart.save! unless current_user.cart
  end

  def cart_item_serializer(cart_item)
    {
      id: cart_item.id,
      product: {
        id: cart_item.product.id,
        name: cart_item.product.name,
        price: cart_item.product.price,
        image: cart_item.product.image
      },
      quantity: cart_item.quantity,
      total_price: cart_item.quantity * cart_item.product.price
    }
  end
end
