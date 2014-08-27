require_dependency "sitreps/application_controller"

module Sitreps
  class SitrepsController < ApplicationController
    inherit_resources
    defaults route_prefix: nil
    respond_to :html, :pdf
    belongs_to :environment, finder: :find_by_slug!
    config[:request_name] = :sitrep

    custom_actions collection: [:print, :submitted]
    actions :all, except: :show

    skip_before_filter :authenticate_user!, only: [:new, :create, :submitted]
    before_filter :check_anonymous_submit_or_authenticate!, only: [:new, :create]

    responders :pdf

    has_scope :for_date, default: Date.current.to_s, only: :print

    def create
      create! { pp(current_user); pp(current_user ? smart_collection_url : submitted_resources_path) }
    end

    protected

    def add_breadcrumbs
      super
      if params[:action] != 'index'
        breadcrumb params[:action].titleize
      end
    end

    def end_of_association_chain
      resource_class.for_environment parent
    end

    helper_method :sitrep_config
    def sitrep_config
      @sitrep_config ||= SitrepConfig.for_environment parent
    end

    def build_resource_params
      [params.fetch(:sitrep, {}).permit(:date, :activity, :submitter_name, :submitter_title, :territory, responses_attributes: [:id, :title, :response, :ordinal]).merge(:creator_id => current_user.try(:id))]
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

    def check_anonymous_submit_or_authenticate!
      authenticate_user! unless sitrep_config && sitrep_config.allow_unauthenticated_submit
    end

    def collection
      @coll ||= apply_scopes(super)
    end
  end
end
