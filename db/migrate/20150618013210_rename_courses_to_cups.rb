class RenameCoursesToCups < ActiveRecord::Migration
  def change
    rename_table :courses, :cups
  end
end
