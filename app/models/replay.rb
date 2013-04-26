# == Schema Information
#
# Table name: replays
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  time        :time
#  winnerid    :integer
#  map         :string(255)
#  player1id   :integer
#  player1name :string(255)
#  player1race :string(255)
#  player2id   :integer
#  player2name :string(255)
#  player2race :string(255)
#  path        :string(255)
#  user_id     :integer
#  gametype    :string(255)
#

class Replay < ActiveRecord::Base
  attr_accessible :name, :path, 
  								:winnerid, :time, :map, :gametype,
  								:player1id, :player1name, :player1race, 
  								:player2id, :player2name, :player2race

  belongs_to :user

end
