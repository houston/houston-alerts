class AddSuppressedToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :suppressed, :boolean, null: false, default: false
  end
end
