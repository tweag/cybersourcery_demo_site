class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :service
      t.string :profile_id
      t.string :access_key
      t.text :secret_key

      t.timestamps
    end
  end
end
