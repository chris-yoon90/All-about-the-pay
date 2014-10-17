class RemoveAccessLevelAndAddIsAdmin < ActiveRecord::Migration
  def change
  	remove_column :employees, :access_level
  	add_column :employees, :isAdmin, :boolean, default: false
  end
end
