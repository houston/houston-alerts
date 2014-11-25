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
      
      
      def excel
        alerts = Alert.includes(:project, :checked_out_by)
        send_data AlertExcelPresenter.new(alerts),
          type: :xlsx,
          filename: "Alerts.xlsx",
          disposition: "attachment"
      end
      
      
      def update
        alert = Alert.find(params[:id])
        attributes = params.pick(:checked_out_by_id)
        attributes.merge! params.pick(:project_id) if alert.can_change_project?
        if alert.update_attributes(attributes)
          head :ok
        else
          render json: alert.errors, status: :unprocessable_entity
        end
      end
      
      
      def reports
        @alerts = Alert.closed
          .joins(:project)
          .pluck(:opened_at, :closed_at, :deadline, :type, "projects.slug", :hours)
          .map { |opened_at, closed_at, deadline, type, project_slug, hours|
            { opened: opened_at,
              closed: closed_at,
              deadline: deadline,
              type: type,
              projectSlug: project_slug,
              hours: (hours.values.map(&:to_d).sum / 60) } }
        render layout: "houston/alerts/minimal"
      end
      
      
    end
  end
end
