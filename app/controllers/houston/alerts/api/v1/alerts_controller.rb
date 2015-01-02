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
          
          
        end
      end
    end
  end
end
