require_dependency "iap/application_controller"

module Iap
  class RecipientsController < ApplicationController
    include Searchable
    inherit_resources
    defaults route_prefix: nil
    config[:request_name] = :recipient
    belongs_to :environment, finder: :find_by_slug!
    actions :all, except: [:show]

    def addresses
      separator = params[:separator] || ';'

      emails = collection.map(&:email) + assigned_addresses
      emails.uniq!

      render text: emails.join(separator), content_type: 'text/plain'
    end

    protected

    def assigned_addresses
      parent.assigned_staff.includes{staff_contact_override}.map(&:primary_email)
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
