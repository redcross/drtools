class AddNssIncidentNumberToEnvironments < ActiveRecord::Migration
  def change
    add_column :environments, :nss_incident_number, :string, after: :arcdata_incident_id
  end
end
