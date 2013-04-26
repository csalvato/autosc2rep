class AddGametypeToReplay < ActiveRecord::Migration
  def change
    add_column :replays, :gametype, :string
  end
end
