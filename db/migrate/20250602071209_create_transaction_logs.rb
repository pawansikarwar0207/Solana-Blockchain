class CreateTransactionLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :transaction_logs do |t|
      t.bigint :user_id, null: false
      t.string :solana_tx
      t.string :status
      t.string :memo
      t.bigint :order_id
      t.decimal :amount
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
