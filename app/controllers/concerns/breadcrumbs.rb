module Breadcrumbs
  extend ActiveSupport::Concern

  included do
    before_filter :add_breadcrumbs!
  end

  def breadcrumb name, url=nil, options=nil
    @breadcrumbs ||= []
    @breadcrumbs << {name: name, url: url, options: options}
  end

  def add_environment_breadcrumb
    if params[:environment_id]
      env = current_environment
      breadcrumb env.to_breadcrumb, env if env
    end
  end

  def add_breadcrumbs!
    add_environment_breadcrumb
    add_breadcrumbs
  end

  def add_breadcrumbs

  end
end