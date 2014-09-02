class AssignedStaffController < InheritedResources::Base
  respond_to :json, :html
  belongs_to :environment
  has_scope :name_contains
  before_filter :authorize_role!
  include Searchable

  protected

  def add_breadcrumbs
    super
    breadcrumb 'Assigned Staff'
  end

  def collection
    @coll ||= super.includes{staff_contact_override}.limit(100)
  end

  def permitted_params
    params.permit(resource_request_name => [:primary_email, :primary_phone])
  end

  def authorize_role!
    roles = [Roles::ASSIGNED_STAFF]
    roles << Roles::Iap::PRODUCER if params[:action] == 'index' && request.format == :json
    authorize! roles
  end
end
