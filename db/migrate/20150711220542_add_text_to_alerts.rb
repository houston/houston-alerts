class AddTextToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :text, :string
  end
end
