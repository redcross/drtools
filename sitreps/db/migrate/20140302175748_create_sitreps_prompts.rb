class CreateSitrepsPrompts < ActiveRecord::Migration
  def change
    create_table :sitreps_prompts do |t|
      t.boolean :required
      t.string :title
      t.references :sitrep_config, index: true
      t.integer :ordinal

      t.timestamps
    end
  end
end
