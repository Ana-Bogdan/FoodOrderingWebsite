class Api::V1::AuthController < Api::V1::ApplicationController
  skip_before_action :authenticate_user!, only: [ :register, :login ]

  api :POST, "/api/v1/register", "Register a new user" if defined?(Apipie)
  def register
    user = User.new(user_params)

    if user.save
      render json: AuthSerializer.serialize_auth_response(user, "User registered successfully.")
    else
      render json: AuthSerializer.serialize_error_response("Registration failed: #{user.errors.full_messages.join(', ')}"), status: :unprocessable_entity
    end
  end

  api :POST, "/api/v1/login", "Login user" if defined?(Apipie)
  def login
    user = User.find_by(email: login_params[:email])

    if user&.valid_password?(login_params[:password])
      render json: AuthSerializer.serialize_auth_response(user, "Logged in successfully.")
    else
      render json: AuthSerializer.serialize_error_response("Invalid email or password."), status: :unauthorized
    end
  end

  api :DELETE, "/api/v1/logout", "Logout user" if defined?(Apipie)
  def logout
    render json: AuthSerializer.serialize_logout_response
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
