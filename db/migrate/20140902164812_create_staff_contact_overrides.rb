class CreateStaffContactOverrides < ActiveRecord::Migration
  def change
    create_table :staff_contact_overrides do |t|
      t.integer :vc_member_number
      t.string :email_override
      t.string :phone_override

      t.timestamps
    end
  end
end
