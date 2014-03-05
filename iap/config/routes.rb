Iap::Engine.routes.draw do
  scope ':environment_id', as: :environment do
    resources :plans, path: 'iap' do
      resource :approval, only: [:new, :create, :destroy]

      resources :attachments, controller: :plan_attachments do
        collection do
          get 'new/upload', action: 'new_upload', as: :new_upload
          scope 'new/drive', controller: 'drive_list' do
            get :switch_user
            get '(:folder_id)', action: 'index', as: :list_drive
            get ':folder_id/assemble', to: 'drive_assemble#new', as: :new_drive
            post ':folder_id/assemble', to: 'drive_assemble#create', as: :create_drive
          end
        end
      end

    end
  end

  get "auth/#{Iap::Engine::IAP_OMNIAUTH_NAME}/callback", to: "drive_list#callback"
end
