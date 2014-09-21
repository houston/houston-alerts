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
      
      
      def update
        alert = Alert.find(params[:id])
        if alert.update_attributes params.pick(:checked_out_by_id)
          head :ok
        else
          render json: alert.errors, status: :unprocessable_entity
        end
      end
      
      
    end
  end
end
