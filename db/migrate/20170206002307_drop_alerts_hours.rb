class DropAlertsHours < ActiveRecord::Migration[5.0]
  def up
    remove_column :alerts, :hours if column_exists?(:alerts, :hours)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
