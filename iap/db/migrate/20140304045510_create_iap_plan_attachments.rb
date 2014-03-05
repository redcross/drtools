class CreateIapPlanAttachments < ActiveRecord::Migration
  def change
    create_table :iap_plan_attachments do |t|
      t.references :plan, index: true
      t.attachment :file
      t.string :title
      t.string :audience
      t.string :attachment_type

      t.timestamps
    end
  end
end
