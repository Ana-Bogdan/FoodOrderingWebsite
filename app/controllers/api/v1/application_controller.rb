class Api::V1::ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_user!

  private

  def authenticate_user!
    unless current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= begin
      token = extract_token_from_header
      return nil unless token

      payload = decode_jwt_token(token)
      return nil unless payload

      User.find_by(id: payload["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end

  def decode_jwt_token(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })[0]
  rescue JWT::DecodeError
    nil
  end

  def extract_token_from_header
    authorization_header = request.headers["Authorization"]
    return nil unless authorization_header

    authorization_header.split(" ").last
  end
end
