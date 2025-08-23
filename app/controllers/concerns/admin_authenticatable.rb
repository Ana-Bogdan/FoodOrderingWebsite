module AdminAuthenticatable
  extend ActiveSupport::Concern

  private

  def require_admin
    unless current_user.admin?
      render json: {
        status: { message: "Access denied. Admin privileges required." }
      }, status: :forbidden
    end
  end
end
