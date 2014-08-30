Houston.config.add_navigation_renderer :alerts do
  if can?(:read, Houston::Alerts::Alert)
    render_nav_link "Alerts", Houston::Alerts::Engine.routes.url_helpers.alerts_path, icon: "fa-bell"
  end
end
