class CreateIapPlanningWorksheetResources < ActiveRecord::Migration
  def change
    create_table :iap_planning_worksheet_resources do |t|
      t.references :planning_worksheet_line
      t.integer :ordinal
      t.string :resource
      t.integer :requested
      t.integer :have
      t.integer :need

      t.timestamps
    end
  end
end
