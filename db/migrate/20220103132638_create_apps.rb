class CreateApps < ActiveRecord::Migration[6.1]
  def change
    create_table :apps do |t|
      t.string  :name, :limit => 30
      t.text    :description
      t.string  :guid, :limit => 30
      t.string  :api_key, :limit => 50
      t.string  :status, :limit => 20
      t.timestamps null: false
    end
    add_index :apps, :guid
    add_index :apps, :api_key, :unique => true
  end
end
