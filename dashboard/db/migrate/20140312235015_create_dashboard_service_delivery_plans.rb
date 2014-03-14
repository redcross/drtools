class CreateDashboardServiceDeliveryPlans < ActiveRecord::Migration
  def change
    create_table :dashboard_service_delivery_plans do |t|
      t.references :environment, index: true
      t.attachment :file
      t.decimal :approved_budget

      t.timestamps
    end
  end
end
