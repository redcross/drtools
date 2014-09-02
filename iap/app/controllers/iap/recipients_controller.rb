require_dependency "iap/application_controller"

module Iap
  class RecipientsController < ApplicationController
    inherit_resources
    include Searchable
    defaults route_prefix: nil
    config[:request_name] = :recipient
    belongs_to :environment, finder: :find_by_slug!
    actions :all, except: [:show]
    custom_actions collection: [:addresses]
    before_filter :authorize_iap_role!

    def addresses
      separator = params[:separator] || ';'
      separator = CGI.unescape separator

      emails = collection.map(&:email) + assigned_addresses
      emails.uniq!

      render text: emails.join(separator), content_type: 'text/plain'
    end

    protected

    def assigned_addresses
      list = []
      types = params.fetch(:q, {}).fetch(:recipient_type_in, [])
      scope = parent.assigned_staff.includes{staff_contact_override}
      if types.include? 'internal'
        list += scope
      elsif types.include? 'leadership'
        list += scope.where{gap.like_any(['OM//DIR', 'OM//AD', '%//CH'])}
      end
      list.map(&:primary_email)
    end

    def permitted_params
      params.permit(:recipient => [:name, :email, :recipient_type, :notes])
    end

    def add_breadcrumbs
      super
      breadcrumb "Recipients", (params[:action] != 'index' && collection_path)
      breadcrumb (resource.name || "New Recipient") if params[:id]
      breadcrumb "New Recipient" if params[:action] == 'new'
    end
  end
end
