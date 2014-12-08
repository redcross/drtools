class AddWorkLocationToForms < ActiveRecord::Migration
  def change
    add_column :iap_work_assignments, :work_location, :string
    add_column :iap_planning_worksheets, :work_location, :string
  end
end
