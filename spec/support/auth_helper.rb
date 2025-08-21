module AuthHelper
  def auth_headers(user)
    { 'Authorization' => "Bearer #{user.generate_jwt}" }
  end

  def admin_headers
    admin_user = create(:user, :admin)
    auth_headers(admin_user)
  end

  def regular_user_headers
    regular_user = create(:user)
    auth_headers(regular_user)
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
