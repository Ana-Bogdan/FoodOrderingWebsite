class OrdersController < ApplicationController
  before_action :require_admin, only: [ :index, :toggle_status ]
  before_action :set_order, only: [ :show, :toggle_status, :destroy, :cancel ]

  def index
    @orders = Order.includes(:user, :order_items, :products).order(created_at: :desc)
  end

  def my_orders
    @orders = current_user.orders.includes(:order_items, :products).order(created_at: :desc)
  end

  def show
    # @order is set by set_order before_action
  end

  def toggle_status
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
  end

  def destroy
    @order.destroy
    flash[:notice] = "Order ##{@order.id} has been removed."
    redirect_to orders_path
  end

  def cancel
    if @order.user == current_user
      @order.update(status: :cancelled)
      flash[:notice] = "Order ##{@order.id} has been cancelled."
      redirect_to my_orders_path
    else
      redirect_to my_orders_path, alert: "You can only cancel your own orders."
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
end
