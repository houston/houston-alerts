Houston::Alerts::Engine.routes.draw do

  scope "alerts" do
    get "", to: "alerts#index", as: :alerts
    get "excel", to: "alerts#excel", as: :alerts_excel
    get "dashboard", to: "alerts#dashboard"

    match ":id", to: "alerts#update", via: [:put, :patch]

    namespace "api" do
      namespace "v1" do
        get "alerts", to: "alerts#index"
        get "alerts/mine", to: "alerts#mine"
      end
    end
  end

  constraints type: Regexp.union(Houston::Alerts.config.types) do
    get ":type/:number", to: "alerts#show", as: :alert
  end

end
