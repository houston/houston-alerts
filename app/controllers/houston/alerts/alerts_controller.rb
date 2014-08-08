module Houston
  module Alerts
    class AlertsController < ApplicationController
      
      
      def index
        @alerts = Alert.open
        render partial: "houston/alerts/alerts/alerts" if request.xhr?
      end
      
      def dashboard
        @alerts = Alert.open
        render layout: "houston/alerts/dashboard"
      end
      
      
    end
  end
end
