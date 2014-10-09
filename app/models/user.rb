class User < ActiveRecord::Base

	has_many :transactions
	
	VALID_NAME_REGEX = /\A[a-zA-z]+\z/i
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	before_save {
		self.first_name.capitalize!;
		self.last_name.capitalize!;
	}

	before_create :create_remember_token

	validates(:first_name, { 
		presence: true, 
		length: { maximum: 50, with: VALID_NAME_REGEX }
		})

	validates(:last_name, { 
		presence: true, 
		length: { maximum: 50, with: VALID_NAME_REGEX }
		})

	validates(:email, { 
		presence: true, 
		format: { with: VALID_EMAIL_REGEX }, 
		uniqueness: { case_sensitive: false }
		})

	validates(:password, {
		presence: true,
		length: { minimum: 8 }
		})
	
	has_secure_password

# Functions for Cookies 
def User.new_remember_token
	SecureRandom.urlsafe_base64
end

def User.encrypt(token)
	Digest::SHA1.hexdigest(token.to_s)
end

private 
def create_remember_token
	self.remember_token = User.encrypt(User.new_remember_token)
end

end
