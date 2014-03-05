class CreateUserEnvironments < ActiveRecord::Migration
  def change
    create_table :user_environments do |t|
      t.references :user, index: true
      t.references :environment, index: true

      t.timestamps
    end
  end
end
