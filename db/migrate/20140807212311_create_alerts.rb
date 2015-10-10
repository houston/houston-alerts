class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :type, null: false
      t.string :key, null: false
      t.string :summary, null: false
      t.string :url, null: false

      t.integer :project_id
      t.integer :checked_out_by_id

      t.timestamp :opened_at, null: false
      t.timestamp :closed_at

      t.index [:type, :key], unique: true
      t.index :opened_at
      t.index :closed_at
    end
  end
end
