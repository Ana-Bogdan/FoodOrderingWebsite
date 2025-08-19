class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include ActionView::Helpers::NumberHelper

  helper_method :current_user, :logged_in?

  before_action :require_login

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Please log in to access this page."
    end
  end

  def ensure_user_cart_exists
    if current_user && !current_user.cart
      current_user.build_cart.save!
    end
  end
end
