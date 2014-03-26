module Dsars
  class ApplicationController < ::ApplicationController
    self.component_name = :dsars
    before_filter :require_enabled_component!

    protected

    def add_breadcrumbs
      breadcrumb "DSARS", reports_path(current_environment)
    end
  end
end
