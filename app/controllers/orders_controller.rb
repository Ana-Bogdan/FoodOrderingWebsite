class OrdersController < ApplicationController
  before_action :require_admin, only: [ :index, :toggle_status ]
  before_action :set_order, only: [ :toggle_status, :destroy, :cancel ]

  def index
    @orders = Order.includes(:user, :order_items, :products).order(created_at: :desc)
  end

  def my_orders
    @orders = current_user.orders.includes(:order_items, :products).order(created_at: :desc)
  end

  def toggle_status
    if @order.completed?
      @order.update(status: :pending)
      flash[:notice] = "Order ##{@order.id} marked as pending."
    else
      @order.update(status: :completed)
      flash[:notice] = "Order ##{@order.id} marked as completed!"
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
      @order.destroy
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
    @order = Order.find(params[:id])
  end
end
