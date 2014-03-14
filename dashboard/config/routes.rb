Dashboard::Engine.routes.draw do
  scope ':environment_id', as: :environment do
    resource :dashboard, controller: :dashboard, only: :show do
      resource :sdp, controller: :service_delivery_plans
    end
  end
end
