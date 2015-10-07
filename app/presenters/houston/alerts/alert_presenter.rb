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
      projectId: project && project.id,
      projectSlug: project && project.slug,
      projectTitle: project && project.name,
      projectColor: project && project.color,
      number: alert.number,
      summary: alert.summary,
      deadline: alert.deadline,
      suppressed: alert.suppressed?,
      url: alert_url(alert),
      type: alert.type,
      checkedOutBy: present_user(alert.checked_out_by),
      checkedOutRemotely: alert.checked_out_remotely?,
      canChangeProject: alert.can_change_project? }
  end
  
protected
  
  def alert_url(alert)
    Houston::Alerts::Engine.routes.url_helpers.alert_url(
      host: Houston.config.host,
      type: alert.type,
      number: alert.number)
  end
  
private
  
  def present_user(user)
    return nil if user.nil?
    { id: user.id,
      name: user.name }
  end
  
end
