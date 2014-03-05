class CreateSitrepsSitrepConfigs < ActiveRecord::Migration
  def change
    create_table :sitreps_sitrep_configs do |t|
      t.references :environment, index: true
      t.boolean :allow_unauthenticated_submit

      t.timestamps
    end
  end
end
