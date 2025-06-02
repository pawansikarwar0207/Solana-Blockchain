class AddColumnToProviderProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :provider_profiles, :verification_status, :string, default: "pending" 
    add_column :provider_profiles, :failure_reason, :text
  end
end
