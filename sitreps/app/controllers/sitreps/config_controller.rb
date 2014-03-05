require_dependency "sitreps/application_controller"

module Sitreps
  class ConfigController < ApplicationController
    inherit_resources
    defaults resource_class: SitrepConfig, singleton: true, route_prefix: nil, route_instance_name: :sitrep_config, instance_name: :sitrep_config
    config[:request_name] = :sitrep_config
    belongs_to :environment, finder: :find_by_slug!

    actions :all, except: [:index, :show]

    private

    def add_breadcrumbs
      breadcrumb "Config", edit_resource_path
    end

    def smart_collection_url
      environment_sitreps_path
    end

    def resource
      @sitrep_config ||= SitrepConfig.find_or_initialize_for_environment parent
    end

    def build_resource
      @sitrep_config ||= begin
        res = SitrepConfig.find_or_initialize_for_environment parent
        res.send :attributes=, *resource_params
        res.prompts.each_with_index do |prompt, idx|
          prompt.ordinal = idx
        end
        res
      end
    end

    def permitted_params
      params.permit(sitrep_config: [:allow_unauthenticated_submit, prompts_attributes: [:id, :title, :required, :ordinal, :_destroy]])
    end
  end
end
