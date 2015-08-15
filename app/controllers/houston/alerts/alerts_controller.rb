module Houston
  module Alerts
    class AlertsController < ApplicationController
      helper "houston/alerts/alert"
      layout "houston/alerts/application"
      skip_before_filter :verify_authenticity_token, only: [:time]
      
      
      helper_method :pull_requests_by_alert_id
      
      
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
      
      
      def pull_requests_by_alert_id
        return @pull_requests_by_alert_id if defined?(@pull_requests_by_alert_id)
        
        @pull_requests_by_alert_id = {}
        begin
          commits = @alerts.includes(commits: :project).flat_map(&:commits)
          projects = commits.flat_map(&:project)
          projects.each do |project|
            next unless project.repo.respond_to?(:pull_requests)
            pull_requests = Houston.benchmark("[alerts] Listing pull requests for #{project.slug}") do
              project.repo.pull_requests
            end
            
            Houston.benchmark("[alerts] Finding commits in #{pull_requests.length} pull requests") do
              pull_requests.each do |pull|
                shas = project.repo.commits_in(pull).map(&:sha)
                
                commits.each do |commit|
                  next unless shas.include?(commit.sha)
                  commit.alerts.each do |alert|
                    @pull_requests_by_alert_id[alert.id] = pull
                  end
                end
              end
            end
          end
        rescue
          Houston.report_exception($!)
        end
        
        @pull_requests_by_alert_id
      end
      
    end
  end
end
