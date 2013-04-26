class AddMoreAttributesToReplay < ActiveRecord::Migration
  def change
    add_column :replays, :filename, :string
    add_column :replays, :time, :time
    add_column :replays, :winnerid, :integer
    add_column :replays, :map, :string
    add_column :replays, :type, :string
    add_column :replays, :player1id, :integer
    add_column :replays, :player1name, :string
    add_column :replays, :player1race, :string
    add_column :replays, :player2id, :integer
    add_column :replays, :player2name, :string
    add_column :replays, :player2race, :string
  end
end
