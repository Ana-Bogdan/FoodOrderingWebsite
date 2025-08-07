class User < ApplicationRecord
  has_secure_password
  has_one :cart, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  after_create :create_cart

  private

  def create_cart
    build_cart.save!
  end
end
