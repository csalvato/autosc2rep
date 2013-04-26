class RemoveTypeFromReplay < ActiveRecord::Migration
  def up
    remove_column :replays, :type
  end

  def down
    add_column :replays, :type, :string
  end
end
