Houston::Alerts::Engine.routes.draw do
  
  get "", to: "alerts#index"
  get "dashboard", to: "alerts#dashboard"
  
  post "timekeeping", to: "alerts#time", as: :timekeeping
  get "thanks", to: "alerts#thanks"
  
end
