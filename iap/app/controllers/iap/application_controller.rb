module Iap
  class ApplicationController < ::ApplicationController
    def add_breadcrumbs
      breadcrumb "IAP", environment_plans_path(parent)
    end
  end
end
