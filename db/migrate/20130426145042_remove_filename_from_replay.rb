class RemoveFilenameFromReplay < ActiveRecord::Migration
  def up
    remove_column :replays, :filename
  end

  def down
    add_column :replays, :filename, :string
  end
end
