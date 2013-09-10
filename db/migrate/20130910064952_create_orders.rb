class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :out_trade_no
      t.string :subject
      t.float :price
      t.integer :quantity

      t.timestamps
    end
  end
end
