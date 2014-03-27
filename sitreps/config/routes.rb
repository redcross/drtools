Sitreps::Engine.routes.draw do
  scope ':environment_id', as: :environment do
    resource :sitrep_config, controller: 'config', as: :sitrep_config#, only: [:edit, :update, :create]
    resources :sitreps, path_names: {new: 'submit'} do
      get :print, on: :collection
    end
  end
end
