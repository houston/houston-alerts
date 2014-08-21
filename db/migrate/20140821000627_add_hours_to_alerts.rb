class AddHoursToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :hours, :hstore, default: {}
  end
end
