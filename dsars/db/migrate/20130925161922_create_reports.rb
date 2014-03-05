class CreateReports < ActiveRecord::Migration
  def change
    create_table :dsars_reports do |t|

      t.string :report_type
      t.integer :report_version

      t.string :dro_number
      t.string :incident_number
      t.string :incident_name

      t.integer :report_number
      t.date :cob_date

      t.string :unit_name
      t.string :unit_id

      t.string :county_name
      t.string :county_id

      t.string :scope

      t.integer :dsars_id

      t.timestamps
    end
  end
end
