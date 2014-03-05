require_dependency "sitreps/application_controller"

module Sitreps
  class SitrepsController < ApplicationController
    inherit_resources
    defaults route_prefix: nil
    respond_to :html, :pdf
    belongs_to :environment, finder: :find_by_slug!
    config[:request_name] = :sitrep

    custom_actions collection: [:print]

    #responders :pdf

    protected

    def add_breadcrumbs
      super
      if params[:action] != 'index'
        breadcrumb params[:action].titleize
      end
    end


    #def resource_path resource=resource
    #  sitrep_path parent, resource
    #end

    #def parent
    #  Environment.find_by_slug! params[:environment_id]
    #end

    def end_of_association_chain
      resource_class.for_environment parent
    end

    helper_method :sitrep_config
    def sitrep_config
      @sitrep_config ||= SitrepConfig.for_environment parent
    end

    def permitted_params
      params.permit(sitrep: [:date, :activity, :submitter_name, :submitter_title, responses_attributes: [:title, :response]])
    end

    def build_resource
      @sitrep ||= super.tap { |sitrep|
        sitrep.date ||= Date.current
        sitrep.submitter_name ||= (current_user && current_user.full_name)
        existing = sitrep.responses.map(&:title)
        sitrep_config.prompts.each do |p|
          sitrep.responses.build title: p.title unless existing.include? p.title
        end
      }
    end
  end
end
