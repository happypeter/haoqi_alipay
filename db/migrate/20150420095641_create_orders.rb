class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :course_id
      t.string :trade_no
      t.string :trade_status
      t.string :subject
      t.float :total_fee

      t.timestamps
    end
  end
end
