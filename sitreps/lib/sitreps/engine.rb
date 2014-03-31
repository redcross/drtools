module Sitreps
  class Engine < ::Rails::Engine
    isolate_namespace Sitreps

    initializer 'activeservice.autoload', :before => :set_autoload_paths do |app|
      app.config.autoload_paths << "#{config.root}/lib"
       app.config.paths["db/migrate"] << "#{config.root}/db/migrate"
    end

    ActiveSupport.on_load :roles do
      register :sitreps, :admin
      register :sitreps, :reviewer
    end
  end
end
