class RemoveMd5hashFromReplay < ActiveRecord::Migration
  def up
    remove_column :replays, :md5hash
  end

  def down
    add_column :replays, :md5hash, :string
  end
end
