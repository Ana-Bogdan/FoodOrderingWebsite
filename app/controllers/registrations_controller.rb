class RegistrationsController < ApplicationController
  skip_before_action :require_login

  def new
    # GET request - display registration form
    @user = User.new
  end

  def create
    # POST request - handle user registration
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully!"
    else
      flash.now[:alert] = "Registration failed. Please check your information."
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
