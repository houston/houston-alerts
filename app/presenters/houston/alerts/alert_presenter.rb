class Houston::Alerts::AlertPresenter
  
  def initialize(alerts)
    @alerts = OneOrMany.new(alerts)
  end
  
  def as_json(*args)
    alerts = @alerts
    alerts = Houston.benchmark "[#{self.class.name.underscore}] Load objects" do
      alerts.load
    end if alerts.is_a?(ActiveRecord::Relation)
    Houston.benchmark "[#{self.class.name.underscore}] Prepare JSON" do
      alerts.map(&method(:alert_to_json))
    end
  end
  
  def alert_to_json(alert)
    project = alert.project
    { id: alert.id,
      openedAt: alert.opened_at,
      closedAt: alert.closed_at,
      projectSlug: project && project.slug,
      projectTitle: project && project.name,
      projectColor: project && project.color,
      summary: alert.summary,
      deadline: alert.deadline,
      url: alert.url,
      type: alert.type }
  end
  
end
