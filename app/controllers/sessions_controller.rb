class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    # GET request - display login form
  end

  def create
    # POST request - handle login authentication
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      sign_in(user)
      redirect_to root_path, notice: "Welcome back, #{user.name}!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    # DELETE request - handle logout
    sign_out(current_user)
    redirect_to root_path, notice: "Successfully logged out!"
  end
end
