require "houston/alerts/engine"
require "houston/alerts/configuration"

module Houston
  module Alerts
    extend self
    
    attr_reader :config
    
  end
  
  Alerts.instance_variable_set :@config, Alerts::Configuration.new
end
