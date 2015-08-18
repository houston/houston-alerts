class AddVerifiedToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :requires_verification, :boolean, null: false, default: false
    add_column :alerts, :verified, :boolean, null: false, default: false
  end
end
