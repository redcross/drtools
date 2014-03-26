module Iap
  class ApplicationController < ::ApplicationController
    self.component_name = :iap
    before_filter :require_enabled_component!
    
    def add_breadcrumbs
      breadcrumb "IAP", environment_plans_path(parent)
    end
  end
end
