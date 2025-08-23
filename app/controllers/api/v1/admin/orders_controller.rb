class Api::V1::Admin::OrdersController < Api::V1::ApplicationController
  include AdminAuthenticatable

  before_action :require_admin
  before_action :set_order, only: [ :show, :update ]

  api :GET, "/api/v1/admin/orders", "List all orders (admin)" if defined?(Apipie)
  def index
    orders = Order.includes(:user, :order_items, :products).order(created_at: :desc)

    render json: {
      status: { code: 200, message: "Orders retrieved successfully." },
      data: AdminOrderSerializer.new(orders).serializable_hash
    }
  end

  api :GET, "/api/v1/admin/orders/:id", "Get specific order (admin)" if defined?(Apipie)
  def show
    render json: {
      status: { code: 200, message: "Order retrieved successfully." },
      data: AdminOrderSerializer.new(@order).serializable_hash
    }
  end

  api :PATCH, "/api/v1/admin/orders/:id", "Update order (admin)" if defined?(Apipie)
  def update
    if @order.update(order_params)
      render json: {
        status: { code: 200, message: "Order updated successfully." },
        data: AdminOrderSerializer.new(@order).serializable_hash
      }
    else
      render json: {
        status: { message: "Update failed: #{@order.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    render json: {
      status: { message: "Invalid parameter: #{e.message}" }
    }, status: :unprocessable_entity
  end

  api :PATCH, "/api/v1/admin/orders/:id/update_status", "Update order status (admin)" if defined?(Apipie)
  def update_status
    order = Order.find(params[:id])
    new_status = params[:order][:status]

    valid_statuses = [ "pending", "completed", "cancelled" ]

    unless valid_statuses.include?(new_status)
      render json: {
        status: { message: "Invalid status. Must be one of: #{valid_statuses.join(', ')}" }
      }, status: :unprocessable_entity
      return
    end

    if order.update(status: new_status)
      render json: {
        status: { code: 200, message: "Order status updated successfully." },
        data: AdminOrderSerializer.new(order).serializable_hash
      }
    else
      render json: {
        status: { message: "Status update failed: #{order.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: "Order not found." }
    }, status: :unprocessable_entity
  end

  api :DELETE, "/api/v1/admin/orders/:id", "Delete order (admin)" if defined?(Apipie)
  def destroy
    order = Order.find(params[:id])

    order.destroy

    render json: {
      status: { code: 200, message: "Order deleted successfully." }
    }
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: "Order not found." }
    }, status: :not_found
  rescue => e
    render json: {
      status: { message: "Failed to delete order: #{e.message}" }
    }, status: :unprocessable_entity
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { message: "Order not found." }
    }, status: :not_found
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
