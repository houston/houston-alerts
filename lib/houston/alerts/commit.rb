require "active_support/concern"

module Houston
  module Alerts
    module Commit
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :alerts, class_name: "Houston::Alerts::Alert"
      end

      def associate_alerts_with_self
        self.alerts = identify_alerts
      end

      def identify_alerts
        extra_attributes.flat_map do |(alert_type, alert_numbers)|
          project.alerts.with_suppressed.with_destroyed.where(type: alert_type, number: alert_numbers).to_a
        end
      end

    end
  end
end
