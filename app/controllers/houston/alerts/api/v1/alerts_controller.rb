module Houston
  module Alerts
    module Api
      module V1
        class AlertsController < ApplicationController
          attr_reader :alerts
          
          before_filter :api_authenticate!, :get_alerts
          skip_before_filter :verify_authenticity_token
          
          
          def index
            render json: AlertPresenter.new(alerts)
          end
          
          def mine
            alerts = self.alerts.checked_out_by(current_user)
            render json: AlertPresenter.new(alerts)
          end
          
          
        private
          
          def get_alerts
            closed = params[:closed] && Date.parse(params[:closed]) rescue nil
            @alerts = closed ? Alert.closed_on(closed) : Alert.open
          end
          
        end
      end
    end
  end
end
