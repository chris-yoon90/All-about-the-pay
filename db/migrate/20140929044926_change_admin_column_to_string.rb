class ChangeAdminColumnToString < ActiveRecord::Migration
  def change
  	rename_column :employees, :admin, :access_level
  	change_column :employees, :access_level, :string, default: 'A'
  end
end
