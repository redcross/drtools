class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  include Breadcrumbs

  around_filter :user_time_zone

  def user_time_zone(&block)
    if env = current_environment
      tz = env.time_zone || Time.zone
      Time.use_zone(tz, &block)
    else
      flash.now[:error] = 'No Environment' unless params[:controller] == 'root' && params[:action] == 'index' || Rails.env.production?
      block.call
    end
  end

  def current_environment
    @environment ||= environment_from_association_chain || environment_from_param
  end

  def environment_from_association_chain
    if respond_to? :association_chain
      association_chain.detect{|chain| chain.is_a? Environment }
    end
  end

  def environment_from_param
    if param = params[:environment_id]
      Environment.find_by_slug!(params[:environment_id])
    end
  end

  cattr_accessor :component_name
  def require_enabled_component!
    unless current_environment.nil? || current_environment.component_enabled?( self.class.component_name )
      flash[:error] = "That DRTools component is not enabled."
      redirect_to main_app.environment_path(current_environment)
    end
  end

end
