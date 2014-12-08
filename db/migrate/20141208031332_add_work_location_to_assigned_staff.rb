class AddWorkLocationToAssignedStaff < ActiveRecord::Migration
  def change
    add_column :assigned_staff, :work_location, :string
  end
end
