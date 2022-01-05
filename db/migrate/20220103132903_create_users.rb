class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :app_id
      t.string  :user_uid, :limit => 30
      t.float   :current_balance, :default => 0.0
      t.string  :status, :limit => 20
      t.text    :description
      t.timestamps null: false
    end
    [:app_id, :user_uid].each do |column|
      add_index :users, column
    end
  end
end
