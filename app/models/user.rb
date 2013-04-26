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
#  dropbox_cursor        :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :dropbox_access_key, :dropbox_access_secret, 
  								:name, :email, :password, :password_confirmation, 
  								:dropbox_cursor
  has_secure_password
	
	has_many :replays, dependent: :destroy

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

	def update_replays 
    client = Dropbox::API::Client.new(:token  => self.dropbox_access_key, :secret => self.dropbox_access_secret)
		delta = client.delta(self.dropbox_cursor)
		self.dropbox_cursor = delta.cursor
		self.save!

    delta.entries.each do |entry|
    	path = entry.path.downcase
    	filename = path.split('/').last
    	extension = filename.split('.').last
			if !entry.is_dir && extension == "sc2replay"
				replay = Replay.find_by_path(path)
				puts "********Entry: #{entry}******"
				if entry.is_deleted
					puts "*******TRYING TO DELETE***********"
					replay.destroy unless replay.nil?
				elsif replay.nil? # replay doesn't exist in DB
	        replay_data = Tassadar::SC2::Replay.new(' ', entry.download)
	        self.replays.create(name: filename, 
				        							path: path, 
				        							winnerid: replay_data.game.winner.id, 
				        							time: replay_data.game.time, 
				        							map: replay_data.game.map, 
				        							gametype: replay_data.game.type.to_s, #for some reason this is a ReverseString class, so use to_s to convert to String.
				  										player1id: replay_data.players.first.id, 
				  										player1name: replay_data.players.first.name, 
				  										player1race: replay_data.players.first.actual_race, 
				  										player2id: replay_data.players.second.id, 
				  										player2name: replay_data.players.second.name, 
				  										player2race: replay_data.players.second.actual_race)
	      else #replay is in the DB (must be updated)
					replay_data = Tassadar::SC2::Replay.new(' ', entry.download)
					replay.name = filename
					replay.path = path
					replay.winnerid = replay_data.game.winner.id
					replay.time = replay_data.game.time
					replay.map = replay_data.game.map
					replay.gametype = replay_data.game.type.to_s #for some reason this is a ReverseString class, so use to_s to convert to String.
					replay.player1id = replay_data.players.first.id
					replay.player1name = replay_data.players.first.name
					replay.player1race = replay_data.players.first.actual_race
					replay.player2id = replay_data.players.second.id
					replay.player2name = replay_data.players.second.name
					replay.player2race = replay_data.players.second.actual_race
					replay.save!
	      end
      end
    end
	end

	def password_changed?
		password != nil && password_confirmation != nil
	end

	private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64 if self.new_record?
    end
end
