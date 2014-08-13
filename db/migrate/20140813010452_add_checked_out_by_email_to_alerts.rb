class AddCheckedOutByEmailToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :checked_out_by_email, :string
  end
end
