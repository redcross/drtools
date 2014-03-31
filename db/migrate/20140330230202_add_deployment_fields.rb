class AddDeploymentFields < ActiveRecord::Migration
  def change
    add_column :deployments, :assign_date, :date
    add_column :deployments, :release_date, :date
    add_index :deployments, [:dr_number, :person_id]
    rename_column :deployments, :person_id, :user_id
  end
end
