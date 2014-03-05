class CreateReportLines < ActiveRecord::Migration
  def change
    create_table :dsars_report_lines do |t|
      t.references :report

      t.integer :line_number

      t.integer :period
      t.integer :total
    end
  end
end
