Houston::Alerts::Engine.routes.draw do
  
  get "", to: "alerts#index"
  get "dashboard", to: "alerts#dashboard"
  
end
