module Houston
  module Alerts
    class Engine < ::Rails::Engine
      isolate_namespace Houston::Alerts
      
      # Enabling assets precompiling under rails 3.1
      if Rails.version >= '3.1'
        initializer :assets do |config|
          Rails.application.config.assets.precompile += %w(
            houston/alerts/application.js
            houston/alerts/application.css )
        end
      end
      
    end
  end
end
