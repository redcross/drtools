module Iap
  class ApplicationController < ::ApplicationController
    self.component_name = :iap
    before_filter :require_enabled_component!
    
    def add_breadcrumbs
      breadcrumb "IAP", environment_plans_path(parent)
    end

    protected

    def authorize_producer!
      authorize! Roles::Iap::PRODUCER
    end

    def authorize_approver!
      authorize! Roles::Iap::APPROVER
    end

    def authorize_iap_role!
      authorize! [Roles::Iap::APPROVER, Roles::Iap::PRODUCER]
    end
  end
end
