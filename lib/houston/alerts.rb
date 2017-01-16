require "houston/alerts/engine"
require "houston/alerts/configuration"

module Houston
  module Alerts
    extend self

    def dependencies
      [ :commits ]
    end

    def config(&block)
      @configuration ||= Alerts::Configuration.new
      @configuration.instance_eval(&block) if block_given?
      @configuration
    end

  end



  register_events {{
    "alert:create"          => params("alert").desc("A new Alert was opened"),
    "alert:{type}:create"   => params("alert").desc("A new Alert of type {type} was opened"),
    "alert:update"          => params("alert").desc("An Alert was updated"),
    "alert:{type}:update"   => params("alert").desc("An Alert of type {type} was updated"),
    "alert:assign"          => params("alert").desc("An Alert was assigned"),
    "alert:{type}:assign"   => params("alert").desc("An Alert of type {type} was assigned"),
    "alert:close"           => params("alert").desc("An Alert was closed"),
    "alert:{type}:close"    => params("alert").desc("An Alert of type {type} was closed"),
    "alert:reopen"          => params("alert").desc("An Alert was reopened"),
    "alert:{type}:reopen"   => params("alert").desc("An Alert of type {type} was reopened"),
    "alert:deployed"        => params("alert", "deploy", "commit").desc("A commit mentioning an Alert was deployed"),
    "alert:{type}:deployed" => params("alert", "deploy", "commit").desc("A commit mentioning an Alert of type {type} was deployed")
  }}

  add_navigation_renderer :alerts do
    name "Alerts"
    path { Houston::Alerts::Engine.routes.url_helpers.alerts_path }
    ability { |ability| ability.can?(:read, Houston::Alerts::Alert) }
  end

end
