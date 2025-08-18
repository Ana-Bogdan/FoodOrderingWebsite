class CartController < ApplicationController
  before_action :ensure_user_cart_exists
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

  def update
    begin
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
    rescue ActiveRecord::RecordNotFound
      redirect_to cart_path, alert: "Cart item not found."
    rescue => e
      redirect_to cart_path, alert: "Failed to update cart item. Please try again."
    end
  end

  def destroy
    begin
      cart_item = @cart.cart_items.find(params[:id])
      product_name = cart_item.product.name
      cart_item.destroy

      redirect_to cart_path, notice: "#{product_name} removed from cart!"
    rescue ActiveRecord::RecordNotFound
      redirect_to cart_path, alert: "Cart item not found."
    rescue => e
      redirect_to cart_path, alert: "Failed to remove item from cart. Please try again."
    end
  end
  
  def order_again
    begin
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
    rescue ActiveRecord::RecordNotFound
      redirect_to my_orders_path, alert: "Order not found."
    rescue => e
      redirect_to my_orders_path, alert: "Failed to reorder. Please try again."
    end
  end

  private

  def set_cart
    @cart = current_user.cart
  end
end
