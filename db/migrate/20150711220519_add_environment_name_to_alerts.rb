class AddEnvironmentNameToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :environment_name, :string
  end
end
