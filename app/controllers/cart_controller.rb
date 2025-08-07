class CartController < ApplicationController
  before_action :require_login
  before_action :ensure_cart_exists
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product)
  end

  def add_item
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_by(product: product)

    if cart_item
      cart_item.update(quantity: cart_item.quantity + 1)
    else
      @cart.cart_items.create(product: product, quantity: 1)
    end

    redirect_back(fallback_location: root_path, notice: "#{product.name} added to cart!")
  end

  def remove_item
    cart_item = @cart.cart_items.find(params[:id])
    product_name = cart_item.product.name
    cart_item.destroy

    redirect_to cart_path, notice: "#{product_name} removed from cart!"
  end

  private

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Please log in to access your cart."
    end
  end

  def set_cart
    @cart = current_user.cart
  end
end
