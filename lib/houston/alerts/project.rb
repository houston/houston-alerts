require "active_support/concern"

module Houston
  module Alerts
    module Project
      extend ActiveSupport::Concern

      included do
        has_many :alerts, class_name: "Houston::Alerts::Alert"
      end

    end
  end
end
