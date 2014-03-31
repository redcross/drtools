class CreateGapPermissions < ActiveRecord::Migration
  def change
    create_table :gap_permissions do |t|
      t.references :environment, index: true
      t.string :group
      t.string :activity
      t.string :position
      t.string :qual

      t.timestamps
    end
  end
end
