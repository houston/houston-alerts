class AddNumberToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :number, :integer
  end
end
