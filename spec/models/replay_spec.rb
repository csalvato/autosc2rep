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

require 'spec_helper'

describe Replay do
  pending "add some examples to (or delete) #{__FILE__}"
end
