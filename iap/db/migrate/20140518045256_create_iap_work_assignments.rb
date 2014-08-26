class CreateIapWorkAssignments < ActiveRecord::Migration
  def change
    create_table :iap_work_assignments do |t|
      t.references :plan, index: true
      t.string :group
      t.string :activity
      t.string :district
      t.string :section_chief_name
      t.string :section_chief_phone
      t.string :activity_manager_name
      t.string :activity_manager_phone
      t.string :supervisor_name
      t.string :supervisor_phone
      t.text :work_assignments
      t.text :special_instructions
      t.string :prepared_by_name
      t.string :prepared_by_title
      t.timestamp :prepared_at

      t.timestamps
    end
  end
end
