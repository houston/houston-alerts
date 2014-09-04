Houston::Alerts::Engine.routes.draw do
  
  get "", to: "alerts#index", as: :alerts
  get "dashboard", to: "alerts#dashboard"
  
  namespace "api" do
    namespace "v1" do
      get "missing-time", to: "alerts#need_time"
      post "time", to: "alerts#post_time"
    end
  end
  
end
