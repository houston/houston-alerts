class AddCanChangeProjectToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :can_change_project, :boolean, default: :false
  end
end
