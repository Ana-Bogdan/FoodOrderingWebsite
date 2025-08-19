class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total_price
    cart_items.sum { |item| item.product.price * item.quantity }
  end

  def item_count
    cart_items.sum(:quantity)
  end
end
