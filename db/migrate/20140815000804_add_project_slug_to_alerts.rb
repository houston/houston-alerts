class AddProjectSlugToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :project_slug, :string
  end
end
