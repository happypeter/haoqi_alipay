class AddTradeStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :trade_status, :string
  end
end
