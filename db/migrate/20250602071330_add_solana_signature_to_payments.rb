class AddSolanaSignatureToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :solana_signature, :string
  end
end
