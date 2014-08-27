class AddOrdinalToWorkAssignmentLines < ActiveRecord::Migration
  def change
    add_column :iap_work_assignment_lines, :ordinal, :integer
  end
end
