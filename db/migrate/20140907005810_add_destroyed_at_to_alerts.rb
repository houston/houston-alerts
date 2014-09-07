class AddDestroyedAtToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :destroyed_at, :timestamp, null: true
  end
end
