class CreateReportDdas < ActiveRecord::Migration
  def change
    create_table :dsars_report_ddas do |t|
      t.references :report
      
      %w(destroyed major minor affected inaccessible).each do |level|
        %w(sfd mh apt).each do |type|
          t.integer "#{type}_#{level}"
        end
      end
      t.integer :completion

      t.timestamps
    end
  end
end
