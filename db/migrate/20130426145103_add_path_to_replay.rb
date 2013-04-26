class AddPathToReplay < ActiveRecord::Migration
  def change
    add_column :replays, :path, :string
  end
end
