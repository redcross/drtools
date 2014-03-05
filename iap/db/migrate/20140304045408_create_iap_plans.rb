class CreateIapPlans < ActiveRecord::Migration
  def change
    create_table :iap_plans do |t|
      t.references :environment, index: true
      t.integer :number
      t.timestamp :period_start
      t.timestamp :period_end
      t.string :status
      t.string :approver_name
      t.string :approver_title
      t.timestamp :approved_at

      t.timestamps
    end
  end
end
