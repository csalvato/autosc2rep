# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  dropbox_access_key    :string(255)
#  dropbox_access_secret :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  password_digest       :string(255)
#  email                 :string(255)
#  remember_token        :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :dropbox_access_key, :dropbox_access_secret, :name, :email, :password, :password_confirmation
  has_secure_password

	before_save { self.email.downcase! }
  before_save :create_remember_token

	VALID_NAME_REGEX = /[A-Z.-]+/i
	validates :name, presence: true, 
									 length: { maximum: 50 }, 
									 format: { with: VALID_NAME_REGEX }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
  									uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }, if: :password_changed?  									
	validates_confirmation_of :password
	validates :password_confirmation, presence: true, if: :password_changed?

	def first_login?
		same_date = (created_at == updated_at )
		if same_date 
			updated_at = Time.now()
			save
		end
		return same_date
	end

	def password_changed?
		password != nil && password_confirmation != nil
	end

	private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end