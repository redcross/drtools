class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments do |t|
      t.references :person, index: true
      t.string :dr_number
      t.string :dr_name
      t.string :gap
      t.string :group
      t.string :activity
      t.string :position
      t.string :qual

      t.timestamps
    end
  end
end
