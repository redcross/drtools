class CreateTerritories < ActiveRecord::Migration
  def change
    create_table :territories do |t|
      t.references :environment, index: true
      t.string :name
      t.string :description
      t.integer :ordinal

      t.timestamps
    end
  end
end
