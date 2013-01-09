class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users, :force => true do |t|
      t.integer :app_id
      t.string  :user_uid, :limit => 30
      t.float   :current_balance, :default => 0.0
      t.string  :status, :limit => 20
      t.text    :description
      t.timestamps
    end
    [:app_id, :user_uid].each do |column|
      add_index :users, column
    end
  end

  def self.down
    [:app_id, :user_uid].each do |column|
      remove_index :users, column
    end
    drop_table :users
  end

end
