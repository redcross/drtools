class CreateIapRecipients < ActiveRecord::Migration
  def change
    create_table :iap_recipients do |t|
      t.references :environment, index: true
      t.string :name
      t.string :email
      t.string :recipient_type
      t.text :notes

      t.timestamps
    end
  end
end
