module Houston
  module Alerts
    class AlertsController < ApplicationController
      helper "houston/alerts/alert"
      layout "houston/alerts/application"
      skip_before_action :verify_authenticity_token, only: [:time]
      before_action :fetch_alerts, only: [:index, :dashboard]


      def index
        authorize! :read, Alert unless request.xhr?
        @alerts = @alerts.with_suppressed
        @title = "Alerts (#{@alerts.reject(&:suppressed?).count})"
      end

      def dashboard
        @limit = params[:limit].to_i
        @count = @alerts.count
        @title = "Alerts (#{@count})"
        @alerts = @alerts.limit(@limit) if @limit > 0

        respond_to do |format|
          format.json { render json: {alerts: AlertPresenter.new(@alerts), count: @count} }
          format.html { render layout: "houston/alerts/dashboard" }
        end
      end


      def show
        @alert = Alert.with_suppressed.find_by!(type: params[:type], number: params[:number])
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
        alert = Alert.with_suppressed.find(params[:id])
        authorize! :update, alert
        attributes = params.permit(:checked_out_by_id, :suppressed).to_h
        attributes[:project_id] = params[:project_id] if alert.can_change_project?
        alert.updated_by = current_user
        if alert.update_attributes(attributes)
          render json: Houston::Alerts::AlertPresenter.new(alert)
        else
          render json: alert.errors, status: :unprocessable_entity
        end
      end


    private

      def fetch_alerts
        @projects = ::Project.unretired.pluck(:id, :name)
          .find_all { |id, name| can?(:manage, Houston::Alerts::Alert.new(project_id: id)) }
          .map { |id, name| { id: id, name: name } }

        teams = Team.none
        teams = current_user.teams if current_user
        params[:teams] = params[:team] if params.key?(:team) && !params.key?(:teams)
        teams = Team.where(id: params[:teams].split(",")) if params.key?(:teams)

        @alerts = Alert.open.preload(:project, :checked_out_by, :pull_requests)
          .where(project_id: teams.project_ids)
        @alerts = @alerts.joins(:project)
          .where(::Project.arel_table[:slug].in params[:only].split(",")) if params.key?(:only)
        @alerts = @alerts.joins(:project)
          .where(::Project.arel_table[:slug].not_in params[:except].split(",")) if params.key?(:except)
      end

    end
  end
end
