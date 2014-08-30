module Houston
  module Alerts
    class AlertsController < ApplicationController
      helper "houston/alerts/alert"
      layout "houston/alerts/application"
      skip_before_filter :verify_authenticity_token, only: [:time]
      
      
      def index
        @title = "Alerts"
        @alerts = Alert.open.includes(:project, :checked_out_by)
        render partial: "houston/alerts/alerts/alerts" if request.xhr?
      end
      
      def dashboard
        @title = "Alerts"
        @alerts = Alert.open.includes(:project, :checked_out_by)
        render layout: "houston/alerts/dashboard"
      end
      
      
      def time
        alerts = Alert.where(id: params["alerts"].keys)
        params["alerts"].each do |alert_id, hours|
          alert = alerts.detect { |alert| alert.id == alert_id.to_i }
          alert.hours = alert.hours.merge(current_user.id => hours)
          alert.save
        end
        redirect_to :thanks
      end
      
      def thanks
      end
      
      
    end
  end
end
