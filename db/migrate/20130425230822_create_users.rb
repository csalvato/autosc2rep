class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :dropbox_access_key
      t.string :dropbox_access_secret

      t.timestamps
    end
  end
end
