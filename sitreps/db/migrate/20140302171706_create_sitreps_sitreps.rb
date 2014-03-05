class CreateSitrepsSitreps < ActiveRecord::Migration
  def change
    create_table :sitreps_sitreps do |t|
      t.references :environment, index: true
      t.date :date
      t.hstore :data
      t.references :creator, index: true
      t.string :activity
      t.string :territory
      t.string :submitter_name
      t.string :submitter_title

      t.timestamps
    end
  end
end
