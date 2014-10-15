class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|
    	t.belongs_to :employee
    	t.belongs_to :group
      	t.timestamps
    end

    add_index :group_memberships, :employee_id
    add_index :group_memberships, :group_id
    add_index :group_memberships, [:employee_id, :group_id], unique: true

  end
end
