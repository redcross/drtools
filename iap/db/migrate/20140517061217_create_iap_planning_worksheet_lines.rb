class CreateIapPlanningWorksheetLines < ActiveRecord::Migration
  def change
    create_table :iap_planning_worksheet_lines do |t|
      t.references :planning_worksheet, index: true
      t.string :identifier
      t.string :work_assignment
      t.string :location
      t.string :arrival_time
      t.integer :ordinal

      t.timestamps
    end
  end
end
