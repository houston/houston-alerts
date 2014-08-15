module Houston
  module Alerts
    class AlertsController < ApplicationController
      helper "houston/alerts/alert"
      
      
      def index
        @alerts = Alert.open.includes(:project, :checked_out_by)
        render partial: "houston/alerts/alerts/alerts" if request.xhr?
      end
      
      def dashboard
        @alerts = Alert.open.includes(:project, :checked_out_by)
        render layout: "houston/alerts/dashboard"
      end
      
      
    end
  end
end
