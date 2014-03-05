module Dsars
  class ApplicationController < ::ApplicationController

    protected

    def add_breadcrumbs
      breadcrumb "DSARS", reports_path(current_environment)
    end
  end
end
