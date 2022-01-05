class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :app_id
      t.integer :user_id
      t.string  :transaction_type, :limit => 10
      t.float   :amount
      t.float   :updated_balance
      t.text    :description
      t.timestamps null: false
    end

    [:app_id, :user_id, :transaction_type].each do |column|
      add_index :transactions, column
    end
  end
end
