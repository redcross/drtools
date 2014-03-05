class EnvironmentsController < ApplicationController
  inherit_resources
  defaults finder: :find_by_slug

  def add_breadcrumbs
    breadcrumb resource.name, resource
  end

  def current_environment
    resource
  end
end