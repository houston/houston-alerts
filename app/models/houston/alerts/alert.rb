module Houston
  module Alerts
    class Alert < ActiveRecord::Base
      self.table_name = "alerts"
      self.inheritance_column = nil
      
      belongs_to :project
      belongs_to :checked_out_by, class_name: "User"
      
      default_value_for :opened_at do; Time.now; end
      
      default_scope { order(:deadline) }
      
      validates :type, :key, :summary, :url, :opened_at, presence: true
      validates :priority, presence: true, inclusion: {:in => %w{high urgent}}
      
      before_save :update_checked_out_by, :if => :checked_out_by_email_changed?
      before_save :update_project, :if => :project_slug_changed?
      before_save :update_deadline, :if => :opened_at_or_priority_changed?
      
      
      
      def self.open
        where(closed_at: nil)
      end
      
      def self.closed
        where(arel_table[:closed_at].not_eq(nil))
      end
      
      def self.without(*keys)
        where(arel_table[:key].not_in(keys.flatten))
      end
      
      def self.synchronize(type, current_alerts)
        Houston.benchmark("[alerts.synchronize] synchronize #{current_alerts.length} #{type.pluralize}") do
          current_keys = current_alerts.map { |attrs| attrs[:key] }
          existing_alerts = where(type: type, key: current_keys)
          existing_keys = existing_alerts.map(&:key)
          
          # Create current alerts that don't exist
          current_alerts.each do |attrs|
            next if existing_keys.member? attrs[:key]
            create! attrs.merge(type: type)
          end
          
          # Update existing alerts that are current
          existing_alerts.each do |existing_alert|
            current_attrs = current_alerts.detect { |attrs| attrs[:key] == existing_alert.key }
            existing_alert.attributes = current_attrs if current_attrs
            existing_alert.save if existing_alert.changed?
          end
          
          # Close alerts that aren't current
          Houston::Alerts::Alert.open
            .where(type: type)
            .without(current_keys)
            .close!
          
          # Reopen alerts that are current
          Houston::Alerts::Alert.closed
            .where(type: type)
            .where(key: current_keys)
            .reopen!
        end; nil
      end
      
      def self.close!
        update_all(closed_at: Time.now)
      end
      
      def self.reopen!
        update_all(closed_at: nil)
      end
      
      
      
      def opened_at_or_priority_changed?
        return true if new_record?
        opened_at_changed? or priority_changed?
      end
      
      def urgent?
        priority == "urgent"
      end
      
      def seconds_remaining
        (deadline - Time.now).to_i
      end
      
      
      
    private
      
      def update_checked_out_by
        self.checked_out_by = User.with_email_address(checked_out_by_email).first
      end
      
      def update_project
        self.project = Project.find_by_slug(project_slug) if project_slug
      end
      
      def update_deadline
        self.deadline = urgent? ? 2.hours.after(opened_at) : 2.days.after(opened_at)
      end
      
    end
  end
end
