class User < ApplicationRecord
  before_create :create_token

  has_secure_password

  def create_token
    self.token_digest = User.token
  end

  def self.token
    string = SecureRandom.urlsafe_base64

    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end
