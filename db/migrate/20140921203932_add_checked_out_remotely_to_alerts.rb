class AddCheckedOutRemotelyToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :checked_out_remotely, :boolean, default: :false
  end
end
