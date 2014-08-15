class AddPriorityAndDeadlineToAlerts < ActiveRecord::Migration
  def up
    add_column :alerts, :priority, :string, null: false, default: "high"
    add_column :alerts, :deadline, :timestamp
    
    Houston::Alerts::Alert.reset_column_information
    Houston::Alerts::Alert.find_each do |alert|
      alert.send :update_deadline
      alert.save
    end
    
    change_column_null :alerts, :deadline, false
  end
  
  def down
    remove_column :alerts, :priority
    remove_column :alerts, :deadline
  end
end
