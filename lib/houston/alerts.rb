require "houston/alerts/engine"
require "houston/alerts/configuration"

module Houston
  module Alerts
    extend self

    def config(&block)
      @configuration ||= Alerts::Configuration.new
      @configuration.instance_eval(&block) if block_given?
      @configuration
    end

  end
end
