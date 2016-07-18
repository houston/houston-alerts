Houston.observer.on "deploy:completed" do |e|
  e.deploy.commits.each do |commit|
    commit.extra_attributes.each do |type, numbers|
      Array(numbers).each do |number|
        alert = Houston::Alerts::Alert.with_suppressed.with_destroyed.where(
          project_id: e.deploy.project_id,
          type: type,
          number: number,
          environment_name: e.deploy.environment_name.downcase).first
        next unless alert

        e = { alert: alert, deploy: e.deploy, commit: commit }
        Houston.observer.fire "alert:deployed", e
        Houston.observer.fire "alert:#{type}:deployed", e
      end
    end
  end
end
