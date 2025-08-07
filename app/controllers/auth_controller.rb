class AuthController < ApplicationController
  def login
    if request.post?
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: "Successfully logged in!"
      else
        flash.now[:alert] = "Invalid email or password"
        render :login
      end
    end
  end

  def register
    if request.post?
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to root_path, notice: "Account created successfully!"
      else
        flash.now[:alert] = "Registration failed. Please check your information."
        render :register
      end
    else
      @user = User.new
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, notice: "Successfully logged out!"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
