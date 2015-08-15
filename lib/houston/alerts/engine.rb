require "houston/alerts/railtie"

module Houston
  module Alerts
    class Engine < ::Rails::Engine
      isolate_namespace Houston::Alerts
      
      initializer :assets do |config|
        Rails.application.config.assets.precompile += %w(
          houston/alerts/application.js
          houston/alerts/application.css
          houston/alerts/dashboard.js
          houston/alerts/dashboard.css )
      end
      
      initializer :append_migrations do |app|
        unless app.root.to_s.match root.to_s
          config.paths["db/migrate"].expanded.each do |expanded_path|
            app.config.paths["db/migrate"] << expanded_path
          end
        end
      end
      
    end
  end
end
