class AddSolanaWalletToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :solana_wallet, :string
  end
end
