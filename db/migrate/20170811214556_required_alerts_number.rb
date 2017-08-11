class RequiredAlertsNumber < ActiveRecord::Migration[5.0]
  def up
    Houston::Alerts::Alert.unscoped.where(number: nil).delete_all
    change_column_null :alerts, :number, false
  end

  def down
    change_column_null :alerts, :number, true
  end
end
