class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
    # GET request - display login form
  end

  def create
    # POST request - handle login authentication
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Successfully logged in!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    # DELETE request - handle logout
    session[:user_id] = nil
    redirect_to root_path, notice: "Successfully logged out!"
  end
end
