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

        @limit = params[:limit].to_i
        @count = @alerts.count
        @title = "Alerts (#{@count})"
        @alerts = @alerts.limit(@limit) if @limit > 0

        @alerts_range = 15.weeks.ago...Time.now
        @alerts_labels = %w{late on-time active}
        @alerts_colors = [
          "rgba(233, 95, 68, 1)",         # late (foreground color when .dashboard.red)
          "rgba(255, 255, 230, 0.435)",   # on-time
          "rgba(255, 255, 230, 0.435)"    # not due yet
        ]

        time_series = <<-SQL
          INNER JOIN generate_series('#{@alerts_range.begin}'::date, '#{@alerts_range.end}'::date, '1 day') AS days(day)
          ON alerts.opened_at::date = days.day
        SQL
        status = <<-SQL
          (CASE WHEN alerts.deadline > now() THEN 'active'
                WHEN alerts.closed_at < alerts.deadline THEN 'on-time'
                ELSE 'late' END)
        SQL
        counter = Hash.new { |hash, key| hash[key] = Hash.new(0) }
        @alerts_data = Houston::Alerts::Alert.all
          .joins(time_series)
          .group("days.day", '"status"')
          .reorder("days.day", '"status"')
          .pluck("days.day", "#{status} \"status\"", "COUNT(*)")
          .each_with_object(counter) { |(date, status, count), hash| hash[date][status] = count }
          .map { |date, counts| [date, *counts.values_at(*@alerts_labels)] }

        respond_to do |format|
          format.json { render json: {alerts: AlertPresenter.new(@alerts), count: @count, graph: @alerts_data} }
          format.html { render layout: "houston/alerts/dashboard" }
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
        alert = Alert.unscope(where: :suppressed).find(params[:id])
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
