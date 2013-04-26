class CreateReplays < ActiveRecord::Migration
  def change
    create_table :replays do |t|
      t.string :name
      t.string :dropbox_copy_ref

      t.timestamps
    end
  end
end
