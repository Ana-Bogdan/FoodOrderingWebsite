class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  enum :status, { pending: 0, completed: 1, cancelled: 2 }

  def total_price
    order_items.sum { |item| item.price_at_time * item.quantity }
  end

  def item_count
    order_items.sum(:quantity)
  end
end
