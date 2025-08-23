class AuthSerializer
  include Alba::Resource

  attributes :id, :name, :email, :role

  attribute :token do |user|
    user.generate_jwt
  end

  def self.serialize_auth_response(user, message)
    {
      status: { code: 200, message: message },
      data: new(user).serializable_hash
    }
  end

  def self.serialize_error_response(message, status_code = :unprocessable_entity)
    {
      status: { message: message }
    }
  end

  def self.serialize_logout_response
    {
      status: { code: 200, message: "Logged out successfully." }
    }
  end
end
