module Houston
  module Alerts
    module Api
      module V1
        class AlertsController < ApplicationController
          before_filter :api_authenticate!
          skip_before_filter :verify_authenticity_token
          
          
          def index
            alerts = Alert.open
            render json: AlertPresenter.new(alerts)
          end

          def mine
            alerts = Alert.open.checked_out_by(current_user)
            render json: AlertPresenter.new(alerts)
          end
          
          
          def need_time
            alerts = Alert.closed(params).unestimated_by(current_user)
            render json: AlertPresenter.new(alerts)
          end
          
          def post_time
            if params["alerts"].is_a? Hash
              alerts = Alert.where(id: params["alerts"].keys)
              params["alerts"].each do |alert_id, hours|
                alert = alerts.detect { |alert| alert.id == alert_id.to_i }
                alert.hours = alert.hours.merge(current_user.id => hours)
                alert.save
              end
              head :ok
            else
              head :unprocessable_entity
            end
          end
          
          
        end
      end
    end
  end
end
