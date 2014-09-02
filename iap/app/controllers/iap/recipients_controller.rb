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
      render text: collection.map(&:email).join(separator)
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
