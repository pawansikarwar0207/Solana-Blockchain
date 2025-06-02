class AddTotalCentsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :total_cents, :integer
    add_column :orders, :payment_method, :string
    add_column :orders, :payment_memo, :string
  end
end
