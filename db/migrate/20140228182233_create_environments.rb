class CreateEnvironments < ActiveRecord::Migration
  def change
    enable_extension :hstore
    create_table :environments do |t|

      t.boolean :enabled
      t.date :active_start_date
      t.date :active_end_date

      t.string :slug, null: false, index: true
      t.string :name
      t.string :short_name

      t.string :cas_incident_number
      t.string :dsars_incident_number
      t.string :dr_number
      t.string :arcdata_incident_id

      t.string :time_zone_raw

      t.hstore :config

      t.timestamps
    end
  end
end
