class CreateIapSubscriptions < ActiveRecord::Migration
  def change
    create_table :iap_subscriptions do |t|
      t.references :environment, index: true
      t.references :user, index: true
      t.string :name
      t.string :email
      t.string :audience

      t.timestamps
    end
  end
end
