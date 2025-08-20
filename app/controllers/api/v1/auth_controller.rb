class Api::V1::AuthController < Api::V1::ApplicationController
  skip_before_action :authenticate_user!, only: [ :register, :login ]

  def register
    user = User.new(user_params)

    if user.save
      token = user.generate_jwt

      render json: {
        status: { code: 200, message: "User registered successfully." },
        data: {
          user: {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role
          },
          token: token
        }
      }
    else
      render json: {
        status: { message: "Registration failed: #{user.errors.full_messages.join(', ')}" }
      }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: login_params[:email])

    if user&.valid_password?(login_params[:password])
      token = user.generate_jwt

      render json: {
        status: { code: 200, message: "Logged in successfully." },
        data: {
          user: {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role
          },
          token: token
        }
      }
    else
      render json: {
        status: { message: "Invalid email or password." }
      }, status: :unauthorized
    end
  end

  def logout
    render json: {
      status: { code: 200, message: "Logged out successfully." }
    }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
