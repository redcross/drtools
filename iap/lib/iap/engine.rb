module Iap
  class Engine < ::Rails::Engine
    isolate_namespace Iap

    IAP_OMNIAUTH_NAME = 'iap_google_oauth'

    initializer 'activeservice.autoload', :before => :set_autoload_paths do |app|
      app.config.autoload_paths << "#{config.root}/lib"
      app.config.paths["db/migrate"] << "#{config.root}/db/migrate"
    end

    initializer 'middleware' do |app|
      app.config.middleware.use OmniAuth::Strategies::GoogleOauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
        access_type: 'online',
        scope: 'userinfo.email,https://www.googleapis.com/auth/drive',
        authorize_params: {
          prompt: 'select_account'
        },
        name: IAP_OMNIAUTH_NAME,
        path_prefix: '/auth'
      }
    end

    ActiveSupport.on_load :roles do
      register :iap, :admin
      register :iap, :producer
      register :iap, :approver
    end
  end
end
