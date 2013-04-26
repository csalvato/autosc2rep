class RemoveDropboxCopyRefFromReplay < ActiveRecord::Migration
  def up
    remove_column :replays, :dropbox_copy_ref
  end

  def down
    add_column :replays, :dropbox_copy_ref, :string
  end
end
