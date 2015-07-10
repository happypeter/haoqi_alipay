class CreateCups < ActiveRecord::Migration
  def change
    create_table :cups do |t|
      t.string :name
      t.float :price
      t.string :cover

      t.timestamps
    end
  end
end
