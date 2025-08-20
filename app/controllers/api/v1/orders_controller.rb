class Api::V1::OrdersController < Api::V1::ApplicationController
  before_action :ensure_user_cart_exists, only: [:create]

  def index
    orders = current_user.orders.includes(:order_items, :products).order(created_at: :desc)
    render json: {
      status: { code: 200, message: 'Orders retrieved successfully.' },
      data: orders.map { |order| order_serializer(order) }
    }
  end

  def show
    order = current_user.orders.find(params[:id])
    render json: {
      status: { code: 200, message: 'Order retrieved successfully.' },
      data: order_serializer(order)
    }
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: 'Order not found.' }
    }, status: :not_found
  end

  def create
    cart = current_user.cart

    if cart.cart_items.empty?
      render json: {
        status: { message: 'Cannot place order with empty cart.' }
      }, status: :unprocessable_entity
      return
    end

    begin
      ActiveRecord::Base.transaction do
        order = current_user.orders.create!(
          total_amount: cart.total_price,
          status: :pending
        )

        cart.cart_items.each do |cart_item|
          order.order_items.create!(
            product: cart_item.product,
            quantity: cart_item.quantity,
            price_at_time: cart_item.product.price
          )
        end

        cart.cart_items.destroy_all

        render json: {
          status: { code: 200, message: 'Order placed successfully!' },
          data: order_serializer(order)
        }
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: {
        status: { message: "Failed to place order: #{e.message}" }
      }, status: :unprocessable_entity
    rescue => e
      render json: {
        status: { message: 'Failed to place order. Please try again.' }
      }, status: :unprocessable_entity
    end
  end

  def update_status
    order = current_user.orders.find(params[:id])
    
    if order.update(order_params)
      render json: {
        status: { code: 200, message: 'Order status updated successfully.' },
        data: order_serializer(order)
      }
    else
      render json: {
        status: { message: "Update failed: #{order.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: 'Order not found.' }
    }, status: :not_found
  end

  def cancel
    order = current_user.orders.find(params[:id])
    
    if order.update(status: :cancelled)
      render json: {
        status: { code: 200, message: 'Order cancelled successfully.' },
        data: order_serializer(order)
      }
    else
      render json: {
        status: { message: "Cancellation failed: #{order.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: 'Order not found.' }
    }, status: :not_found
  end

  def my_orders
    orders = current_user.orders.includes(:order_items, :products).order(created_at: :desc)
    render json: {
      status: { code: 200, message: 'My orders retrieved successfully.' },
      data: orders.map { |order| order_serializer(order) }
    }
  end

  def reorder
    order = current_user.orders.find(params[:id])
    
    # Ensure user has a cart
    ensure_user_cart_exists
    
    # Clear current cart
    current_user.cart.cart_items.destroy_all
    
    # Add order items back to cart
    order.order_items.each do |order_item|
      current_user.cart.cart_items.create!(
        product: order_item.product,
        quantity: order_item.quantity
      )
    end
    
    render json: {
      status: { code: 200, message: 'Order items added to cart successfully!' },
      data: {
        cart_items: current_user.cart.cart_items.map { |item| cart_item_serializer(item) }
      }
    }
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: 'Order not found.' }
    }, status: :not_found
  rescue => e
    render json: {
      status: { message: "Reorder failed: #{e.message}" }
    }, status: :unprocessable_entity
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end

  def ensure_user_cart_exists
    current_user.build_cart.save! unless current_user.cart
  end

  def order_serializer(order)
    {
      id: order.id,
      total_amount: order.total_amount,
      status: order.status,
      created_at: order.created_at,
      updated_at: order.updated_at,
      order_items: order.order_items.map { |item| order_item_serializer(item) }
    }
  end

  def order_item_serializer(order_item)
    {
      id: order_item.id,
      product: {
        id: order_item.product.id,
        name: order_item.product.name,
        price: order_item.product.price
      },
      quantity: order_item.quantity,
      price_at_time: order_item.price_at_time
    }
  end

  def cart_item_serializer(cart_item)
    {
      id: cart_item.id,
      product: {
        id: cart_item.product.id,
        name: cart_item.product.name,
        price: cart_item.product.price
      },
      quantity: cart_item.quantity
    }
  end
end
