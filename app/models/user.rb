class User < ApplicationRecord
  before_create :create_token

  has_secure_password

  def create_token
    self.token_digest = User.encrypt_token (User.generate_token)
  end
  def self.generate_token
     SecureRandom.urlsafe_base64
  end
  def self.encrypt_token (token)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(token, cost: cost)
  end
  def forget
    update_attribute(:token_digest,nil)
  end

end
