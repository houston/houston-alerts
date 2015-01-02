Houston::Alerts::Engine.routes.draw do
  
  get "", to: "alerts#index", as: :alerts
  get "excel", to: "alerts#excel", as: :alerts_excel
  get "dashboard", to: "alerts#dashboard"
  
  put ":id", to: "alerts#update"
  
  get "reports", to: "alerts#reports"
  
  namespace "api" do
    namespace "v1" do
      get "alerts", to: "alerts#index"
      get "alerts/mine", to: "alerts#mine"
    end
  end
  
end
