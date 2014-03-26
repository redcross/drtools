module Sitreps
  class ApplicationController < ::ApplicationController
    self.component_name = :sitreps
    before_filter :require_enabled_component!
    
    def add_breadcrumbs
      breadcrumb 'Sitreps', collection_path
    end
  end
end
