module Houston
  module Alerts
    class Alert < ActiveRecord::Base
      self.table_name = "alerts"
      self.inheritance_column = nil
      
      belongs_to :project
      belongs_to :checked_out_by, class_name: "User"
      
      default_value_for :opened_at do; Time.now; end
      
      validates :type, :key, :summary, :url, :opened_at, presence: true
      
      
      
      def self.open
        where(closed_at: nil)
      end
      
      def self.closed
        where(arel_table[:closed_at].not_eq(nil))
      end
      
      def self.synchronize(type, current_alerts)
        Houston.benchmark("[alerts.synchronize] synchronizing #{current_alerts.length} #{type.pluralize}") do
          current_keys = current_alerts.map { |attrs| attrs[:key] }
          existing_keys = where(type: type, key: current_keys).pluck(:key)
          
          # Create current alerts that don't exist
          current_alerts.reject { |attrs| existing_keys.member?(attrs[:key]) }.each do |attrs|
            create! attrs.merge(type: type)
          end
          
          # Close alerts that aren't current
          stale_alerts = existing_keys - current_keys
          Houston::Alerts::Alert.open
            .where(type: type, key: stale_alerts)
            .close! if stale_alerts.any?
        end; nil
      end
      
      def self.close!
        update_all(closed_at: Time.now)
      end
      
      
      
      def checked_out_by_email=(email)
        self.checked_out_by = User.with_email_address(email).first
      end
      
      
      
    end
  end
end
