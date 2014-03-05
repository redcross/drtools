class CreateSitrepsResponses < ActiveRecord::Migration
  def change
    create_table :sitreps_responses do |t|
      t.references :sitrep, index: true
      t.string :title
      t.text :response
      t.integer :ordinal

      t.timestamps
    end
  end
end
