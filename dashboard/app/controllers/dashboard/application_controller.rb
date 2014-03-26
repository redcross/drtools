module Dashboard
  class ApplicationController < ::ApplicationController
    self.component_name = :dashboard
    before_filter :require_enabled_component!
  end
end
