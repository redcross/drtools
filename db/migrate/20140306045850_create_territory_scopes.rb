class CreateTerritoryScopes < ActiveRecord::Migration
  def change
    create_table :territory_scopes do |t|
      t.references :territory, index: true
      t.string :scope_type
      t.string :unit_code

      t.timestamps
    end
  end
end
