class AddRoleFields < ActiveRecord::Migration
  def change
    add_column :users, :member_number, :string, index: true
    add_column :user_environments, :member_number, :string, index: true
    add_column :user_environments, :roles, :string, array: true
    add_column :gap_permissions, :roles, :string, array: true
  end
end
