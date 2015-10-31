module Houston
  module Alerts
    class AlertsController < ApplicationController
      helper "houston/alerts/alert"
      layout "houston/alerts/application"
      skip_before_filter :verify_authenticity_token, only: [:time]


      def index
        authorize! :read, Alert unless request.xhr?
        @alerts = Alert.open
          .with_suppressed
          .includes(:project, :checked_out_by, commits: :pull_requests)
        @title = "Alerts (#{@alerts.reject(&:suppressed?).count})"
      end

      def dashboard
        @alerts = Alert.open
          .includes(:project, :checked_out_by, commits: :pull_requests)
        @title = "Alerts (#{@alerts.count})"

        if request.xhr?
          render partial: "houston/alerts/alerts/alerts"
        else
          render layout: "houston/alerts/dashboard"
        end
      end


      def show
        @alert = Alert.find_by!(type: params[:type], number: params[:number])
        redirect_to @alert.url unless unfurling?
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
        attributes = params.pick(:checked_out_by_id, :suppressed)
        attributes.merge! params.pick(:project_id) if alert.can_change_project?
        alert.updated_by = current_user
        if alert.update_attributes(attributes)
          render json: Houston::Alerts::AlertPresenter.new(alert)
        else
          render json: alert.errors, status: :unprocessable_entity
        end
      end


    end
  end
end
