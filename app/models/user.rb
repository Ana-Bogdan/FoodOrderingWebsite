class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy

  enum :role, { user: 0, admin: 1 }

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  after_create :ensure_cart_exists

  def generate_jwt
    JWT.encode(
      {
        user_id: id,
        email: email,
        exp: 24.hours.from_now.to_i
      },
      Rails.application.credentials.secret_key_base,
      "HS256"
    )
  end

  private

  def ensure_cart_exists
    build_cart.save!
  end
end
