class OrdersController < ApplicationController
  before_action :require_admin, only: [ :index, :update ]
  before_action :set_order, only: [ :show, :update, :destroy, :cancel ]
  before_action :ensure_user_cart_exists, only: [ :create ]

  def index
    @orders = Order.includes(:user, :order_items, :products).order(created_at: :desc)
  end

  def my_orders
    @orders = current_user.orders.includes(:order_items, :products).order(created_at: :desc)
  end

  def show
    # @order is set by set_order before_action
  end

  def create
    @cart = current_user.cart

    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Cannot place order with empty cart."
      return
    end

    begin
      ActiveRecord::Base.transaction do
        order = current_user.orders.create!(
          total_amount: @cart.total_price,
          status: :pending
        )

        @cart.cart_items.each do |cart_item|
          order.order_items.create!(
            product: cart_item.product,
            quantity: cart_item.quantity,
            price_at_time: cart_item.product.price
          )
        end

        @cart.cart_items.destroy_all

        redirect_to cart_path, notice: "Order placed successfully!"
      end
    rescue ActiveRecord::RecordInvalid => e
      redirect_to cart_path, alert: "Failed to place order: #{e.message}"
    rescue => e
      redirect_to cart_path, alert: "Failed to place order. Please try again."
    end
  end

  def update
    begin
      case @order.status
      when "completed"
        @order.update(status: :pending)
        flash[:notice] = "Order ##{@order.id} marked as pending."
      when "pending"
        @order.update(status: :completed)
        flash[:notice] = "Order ##{@order.id} marked as completed!"
      when "cancelled"
        @order.update(status: :pending)
        flash[:notice] = "Order ##{@order.id} marked as pending."
      end

      redirect_to orders_path
    rescue => e
      flash[:alert] = "Failed to update order status. Please try again."
      redirect_to orders_path
    end
  end

  def destroy
    begin
      @order.destroy
      flash[:notice] = "Order ##{@order.id} has been removed."
      redirect_to orders_path
    rescue => e
      flash[:alert] = "Failed to delete order. Please try again."
      redirect_to orders_path
    end
  end

  def cancel
    begin
      if @order.user == current_user
        @order.update(status: :cancelled)
        flash[:notice] = "Order ##{@order.id} has been cancelled."
        redirect_to my_orders_path
      else
        redirect_to my_orders_path, alert: "You can only cancel your own orders."
      end
    rescue => e
      flash[:alert] = "Failed to cancel order. Please try again."
      redirect_to my_orders_path
    end
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied. Admin privileges required."
    end
  end

  def set_order
    orders_scope = current_user.admin? ? Order.all : current_user.orders
    @order = orders_scope.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to my_orders_path, alert: "Order not found or access denied."
  end

  def ensure_user_cart_exists
    unless current_user.cart
      redirect_to cart_path, alert: "Your cart is empty. Please add items to your cart before placing an order."
    end
  end
end
