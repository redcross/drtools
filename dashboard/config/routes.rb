Dashboard::Engine.routes.draw do
  scope ':environment_id' do
    get :dashboard, to: 'dashboard#index'
    get "chart/:line_number", as: :graph, to: 'chart#show'
  end
end
