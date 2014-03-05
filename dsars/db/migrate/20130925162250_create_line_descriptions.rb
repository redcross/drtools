class CreateLineDescriptions < ActiveRecord::Migration
  def change
    create_table :dsars_line_descriptions do |t|
      t.string :report_type
      t.integer :report_version
      t.integer :line_number
      t.string :name
      t.text :description
      t.boolean :has_period, default: true
      t.boolean :has_total, default: true
      t.string :format

      t.timestamps
    end
  end
end
