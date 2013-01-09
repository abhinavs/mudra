class CreateTransactions < ActiveRecord::Migration

  def self.up
    create_table :transactions, :force => true do |t|
      t.integer :app_id
      t.integer :user_id
      t.string  :transaction_type, :limit => 10
      t.float   :amount
      t.float   :updated_balance
      t.text    :description
      t.timestamps
    end
    [:app_id, :user_id, :transaction_type].each do |column|
      add_index :transactions, column
    end
  end

  def self.down
    [:app_id, :user_id, :transaction_type].each do |column|
      remove_index :transactions, column
    end
    drop_table :transactions
  end

end
