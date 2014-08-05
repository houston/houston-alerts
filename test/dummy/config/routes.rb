Rails.application.routes.draw do

  mount Alerts::Engine => "/alerts"
end
