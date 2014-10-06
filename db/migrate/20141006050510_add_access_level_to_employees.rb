class AddAccessLevelToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :access_level, :string, default: 'A'
  end
end
