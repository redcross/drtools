class CreateIapWorkAssignmentLines < ActiveRecord::Migration
  def change
    create_table :iap_work_assignment_lines do |t|
      t.references :work_assignment, index: true
      t.string :resource_identifier
      t.string :leader
      t.integer :num_persons
      t.string :contact
      t.string :reporting_location

      t.timestamps
    end
  end
end
