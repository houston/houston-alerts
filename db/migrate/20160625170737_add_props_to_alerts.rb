class AddPropsToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :props, :jsonb, default: "{}"
  end
end
