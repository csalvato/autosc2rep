class AddMd5hashToReplay < ActiveRecord::Migration
  def change
    add_column :replays, :md5hash, :string
  end
end
