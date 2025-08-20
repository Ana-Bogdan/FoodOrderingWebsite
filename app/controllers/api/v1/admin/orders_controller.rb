class Api::V1::Admin::OrdersController < Api::V1::ApplicationController
  before_action :require_admin
  before_action :set_order, only: [:show, :update]

  def index
    orders = Order.includes(:user, :order_items, :products).order(created_at: :desc)
    render json: {
      status: { code: 200, message: 'Orders retrieved successfully.' },
      data: orders.map { |order| admin_order_serializer(order) }
    }
  end

  def show
    render json: {
      status: { code: 200, message: 'Order retrieved successfully.' },
      data: admin_order_serializer(@order)
    }
  end

  def update
    if @order.update(order_params)
      render json: {
        status: { code: 200, message: 'Order updated successfully.' },
        data: admin_order_serializer(@order)
      }
    else
      render json: {
        status: { message: "Update failed: #{@order.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  end

  def update_status
    order = Order.find(params[:id])
    
    if order.update(status: params[:order][:status])
      render json: {
        status: { code: 200, message: 'Order status updated successfully.' },
        data: admin_order_serializer(order)
      }
    else
      render json: {
        status: { message: "Status update failed: #{order.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: 'Order not found.' }
    }, status: :not_found
  end

  private

  def require_admin
    unless current_user.admin?
      render json: {
        status: { message: 'Access denied. Admin privileges required.' }
      }, status: :forbidden
    end
  end

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: 'Order not found.' }
    }, status: :not_found
  end

  def order_params
    params.require(:order).permit(:status)
  end

  def admin_order_serializer(order)
    {
      id: order.id,
      user: {
        id: order.user.id,
        name: order.user.name,
        email: order.user.email
      },
      total_amount: order.total_amount,
      status: order.status,
      created_at: order.created_at,
      updated_at: order.updated_at,
      order_items: order.order_items.map { |item| admin_order_item_serializer(item) }
    }
  end

  def admin_order_item_serializer(order_item)
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
end
