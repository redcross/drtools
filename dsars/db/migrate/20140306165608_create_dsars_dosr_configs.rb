class CreateDsarsDosrConfigs < ActiveRecord::Migration
  def change
    create_table :dsars_dosr_configs do |t|
      t.references :environment, index: true
      t.integer :dosr_line_number
      t.string :name
      t.integer :lines, array: true, default: []
      t.boolean :enabled, default: true
      t.string :format
      t.text :description
      t.timestamps
    end
    add_index :dsars_dosr_configs, :lines, using: 'gin'
  end
end
