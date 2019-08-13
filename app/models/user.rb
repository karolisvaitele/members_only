class User < ApplicationRecord
    attr_accessor :remember_token
    before_create :create_remember_digest

    validates :name, length: {minimum: 4, maximum: 20}, presence: true
    validates :email, length: {maximum: 255}, presence: true, uniqueness: {case_sensitive: false}
    validates :password, length: {minimum: 6, maximum: 255}, presence: true

    has_secure_password
    has_many :posts, foreign_key: "user_id"

    # Returns the hash digest of the given string.
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # Remembers a user in the database for use in persistent sessions.
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    private

        def create_remember_digest
            self.remember_token = User.new_token
            self.remember_digest = User.digest(remember_token)
        end
end
