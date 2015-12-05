require "active_support/concern"

module Houston
  module Alerts
    module User
      extend ActiveSupport::Concern

      included do
        has_many :alerts, class_name: "Houston::Alerts::Alert", foreign_key: :checked_out_by_id
      end

    end
  end
end
