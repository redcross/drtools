class AddUserFields < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :email, :string

    add_column :users, :region_id, :integer
    add_column :users, :vc_is_active, :boolean
  end
end
