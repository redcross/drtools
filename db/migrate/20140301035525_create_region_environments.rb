class CreateRegionEnvironments < ActiveRecord::Migration
  def change
    create_table :region_environments do |t|
      t.references :region, index: true
      t.references :environment, index: true

      t.timestamps
    end
  end
end
