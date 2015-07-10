class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :out_trade_no
      t.string :subject
      t.float :total_fee
      t.integer :cup_id
      t.string :trade_status

      t.timestamps
    end
  end
end
