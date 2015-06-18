class RenameColumnTradeNoOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :trade_no, :out_trade_no
  end
end
