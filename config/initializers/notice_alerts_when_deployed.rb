Houston.observer.on "deploy:completed" do |deploy|
  deploy.commits.each do |commit|
    commit.extra_attributes.each do |type, numbers|
      Array(numbers).each do |number|
        alert = Houston::Alerts::Alert.with_suppressed.with_destroyed.where(
          project_id: deploy.project_id,
          type: type,
          number: number,
          environment_name: deploy.environment_name.downcase).first
        next unless alert

        Houston.observer.fire "alert:deployed", alert, deploy, commit
        Houston.observer.fire "alert:#{type}:deployed", alert, deploy, commit
      end
    end
  end
end
