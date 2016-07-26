module Houston
  module Alerts
    class Mailer < ViewMailer
      helper AlertHelper

      self.stylesheets = stylesheets + %w{
        houston/alerts/alerts.scss
      }

      def self.deliver_to!(*recipients)
        recipients.flatten.each do |email|
          developer = ::User.find_by_email!(email)
          Houston.deliver! daily_report(developer)
        end
      end

      def daily_report(developer, options={})
        @alerts = Houston::Alerts::Alert.open.checked_out_by developer

        return NullMessage.new if @alerts.none?

        mail({
          to:       developer,
          subject:  "You have #{@alerts.length} open #{@alerts.length == 1 ? "alert" : "alerts"}",
          template: "houston/alerts/mailer/daily_report"
        })
      end

    private

      class NullMessage
        def method_missing(*args)
          self
        end
      end

    end
  end
end
