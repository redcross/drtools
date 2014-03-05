DRTools::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {omniauth_callbacks: "users/callbacks"}
  devise_scope :user do
    get '/users/sign_in', :to => 'users/sessions#new', :as => :new_user_session
    delete '/users/sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  end
  #resources :auth, only: [:index, :create, :destroy] do
  #  get ':service/callback', action: :create
  #end
  
  mount Dsars::Engine, at: '/'
  mount Dashboard::Engine, at: '/'
  mount Sitreps::Engine, at: '/'
  mount Iap::Engine, at: '/'

  root to: 'root#index'

  resources '', as: :environments, controller: 'environments', only: :show

end
