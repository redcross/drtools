class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  after_action :check_authorization!

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

  helper_method :current_ability, :role?
  def current_ability
    @ability ||= EnvironmentAbility.new current_environment, current_user
  end
  def role? *args
    current_ability.role? *args
  end

  class AccessDenied < StandardError; end

  def authorize! role
    @authorized = true
    raise AccessDenied unless current_ability.role?(role)
  end

  def check_authorization!
    #raise "Authorization Not Performed" unless @authorized
    flash.now[:error] = "Authorization Not Performed" unless @authorized
  end

  rescue_from AccessDenied do |e|
    respond_to do |fmt|
      fmt.any(:html) { 
        flash[:error] = "You are not authorized to perform that action."
        begin
          redirect_to :back
        rescue ActionController::RedirectBackError
          redirect_to main_app.environment_path(current_environment)
        end
      }
      fmt.all { head :forbidden }
    end
  end

end
