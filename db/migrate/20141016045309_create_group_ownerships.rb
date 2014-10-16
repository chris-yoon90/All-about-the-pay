class CreateGroupOwnerships < ActiveRecord::Migration
  def change
    create_table :group_ownerships do |t|
      t.belongs_to :employee
      t.belongs_to :group

      t.timestamps
    end

    add_index :group_ownerships, :employee_id
    add_index :group_ownerships, :group_id, unique: true

  end
end
