module Houston
  module Alerts
    class AlertsController < ApplicationController
      helper "houston/alerts/alert"
      layout "houston/alerts/application"
      skip_before_filter :verify_authenticity_token, only: [:time]
      
      
      def index
        @title = "Alerts"
        authorize! :read, Alert unless request.xhr?
        @alerts = Alert.open.includes(:project, :checked_out_by)
        render partial: "houston/alerts/alerts/alerts" if request.xhr?
      end
      
      def dashboard
        @title = "Alerts"
        @alerts = Alert.open.includes(:project, :checked_out_by)
        render layout: "houston/alerts/dashboard"
      end
      
      
      def excel
        authorize! :read, Alert
        alerts = Alert.includes(:project, :checked_out_by)
        send_data AlertExcelPresenter.new(alerts),
          type: :xlsx,
          filename: "Alerts.xlsx",
          disposition: "attachment"
      end
      
      
      def update
        alert = Alert.find(params[:id])
        authorize! :update, alert
        attributes = params.pick(:checked_out_by_id)
        attributes.merge! params.pick(:project_id) if alert.can_change_project?
        alert.updated_by = current_user
        if alert.update_attributes(attributes)
          head :ok
        else
          render json: alert.errors, status: :unprocessable_entity
        end
      end
      
      
    end
  end
end
