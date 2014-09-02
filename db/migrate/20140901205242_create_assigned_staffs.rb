class CreateAssignedStaffs < ActiveRecord::Migration
  def change
    create_table :assigned_staff do |t|
      t.references :environment, index: true
      t.string :name
      t.string :cell_phone
      t.string :home_phone
      t.string :work_phone
      t.string :email
      t.string :gap
      t.integer :member_number
      t.integer :vc_id

      t.timestamps
    end
  end
end
