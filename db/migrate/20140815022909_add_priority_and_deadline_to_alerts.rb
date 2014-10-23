class AddPriorityAndDeadlineToAlerts < ActiveRecord::Migration
  def up
    add_column :alerts, :priority, :string, null: false, default: "high"
    add_column :alerts, :deadline, :timestamp
    
    Houston::Alerts::Alert.reset_column_information
    Houston::Alerts::Alert.unscoped.find_each do |alert|
      alert.update_column :deadline, alert.send(:update_deadline)
    end
    
    change_column_null :alerts, :deadline, false
  end
  
  def down
    remove_column :alerts, :priority
    remove_column :alerts, :deadline
  end
end
