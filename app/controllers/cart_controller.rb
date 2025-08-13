class CartController < ApplicationController
  before_action :ensure_cart_exists
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product)
  end

  def create
    begin
      product = Product.find(params[:product_id])
      cart_item = @cart.cart_items.find_by(product: product)

      if cart_item
        cart_item.update(quantity: cart_item.quantity + 1)
      else
        @cart.cart_items.create(product: product, quantity: 1)
      end

      redirect_back(fallback_location: root_path, notice: "#{product.name} added to cart!")
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: root_path, alert: "Product not found.")
    end
  end

  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    product_name = cart_item.product.name
    cart_item.destroy

    redirect_to cart_path, notice: "#{product_name} removed from cart!"
  end

  def update
    cart_item = @cart.cart_items.find(params[:id])
    action = params[:action_type]

    case action
    when "increment"
      cart_item.update(quantity: cart_item.quantity + 1)
      redirect_to cart_path, notice: "#{cart_item.product.name} quantity increased!"
    when "decrement"
      if cart_item.quantity > 1
        cart_item.update(quantity: cart_item.quantity - 1)
        redirect_to cart_path, notice: "#{cart_item.product.name} quantity decreased!"
      else
        cart_item.destroy
        redirect_to cart_path, notice: "#{cart_item.product.name} removed from cart!"
      end
    else
      redirect_to cart_path, alert: "Invalid action."
    end
  end

  def order_again
    order = Order.find(params[:order_id])

    unless order.user == current_user || current_user&.admin?
      redirect_to my_orders_path, alert: "You can only reorder your own orders."
      return
    end

    @cart.cart_items.destroy_all

    order.order_items.each do |order_item|
      @cart.cart_items.create(
        product: order_item.product,
        quantity: order_item.quantity
      )
    end

    redirect_to cart_path, notice: "Order items added to cart! Review and place your order."
  end

  def place_order
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Cannot place order with empty cart."
      return
    end

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
  rescue => e
    redirect_to cart_path, alert: "Failed to place order. Please try again."
  end

  private

  def set_cart
    @cart = current_user.cart
  end
end
