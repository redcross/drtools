module Sitreps
  class ApplicationController < ::ApplicationController
    def add_breadcrumbs
      breadcrumb 'Sitreps', collection_path
    end
  end
end
