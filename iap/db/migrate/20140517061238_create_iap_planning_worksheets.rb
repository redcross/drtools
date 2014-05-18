class CreateIapPlanningWorksheets < ActiveRecord::Migration
  def change
    create_table :iap_planning_worksheets do |t|
      t.references :plan, index: true
      t.timestamp :prepared_at
      t.string :prepared_by_name
      t.string :prepared_by_title
      t.boolean :completed
      t.string :district
      t.string :group
      t.string :activity

      t.timestamps
    end
  end
end
