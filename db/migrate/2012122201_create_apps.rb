class CreateApps < ActiveRecord::Migration

  def self.up
    create_table :apps, :force => true do |t|
      t.string  :name, :limit => 30
      t.text    :description
      t.string  :guid, :limit => 30
      t.string  :api_key, :limit => 50
      t.string  :status, :limit => 20
      t.timestamps
    end
    add_index :apps, :guid
    add_index :apps, :api_key, :unique => true
  end

  def self.down
    [:guid, :api_key].each do |column|
      remove_index :apps, column
    end
    drop_table :apps
  end

end
