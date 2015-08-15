require "houston/alerts/commit"
require "houston/alerts/project"

module Houston
  module Alerts
    class Railtie < ::Rails::Railtie

      # The block you pass to this method will run for every request in
      # development mode, but only once in production.
      config.to_prepare do
        ::Commit.send(:include, Houston::Alerts::Commit)
        ::Project.send(:include, Houston::Alerts::Project)
      end

    end
  end
end
