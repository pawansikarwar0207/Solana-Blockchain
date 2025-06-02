class CreateProviderProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :provider_profiles do |t|
      t.references :order, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true 
      t.string :first_name
      t.string :last_name
      t.string :npi_number
      t.string :license_number
      t.string :state
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
