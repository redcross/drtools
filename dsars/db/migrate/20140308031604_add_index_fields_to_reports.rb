class AddIndexFieldsToReports < ActiveRecord::Migration
  def change
    add_index :dsars_report_lines, [:report_id]
    add_index :dsars_reports, [:report_type, :report_number]
  end
end
