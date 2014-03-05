module Dsars
  class InputsController < ApplicationController
    #include ActionController::Live
    inherit_resources
    belongs_to :environment, finder: :find_by_slug

    def show
      @since_date = 1.day.ago.to_date
      @dr_number = parent.dr_number
    end

    def input
      dro_number = params[:dr_number]
      since = Date.parse params[:data_since]
      consolidated_only = params[:consolidated_only] == '1'

      response.headers['Content-Type'] = 'text/plain'
      Dsars::Importer.import(ENV['DSARS_USERNAME'], ENV['DSARS_PASSWORD'], dro_number, since, consolidated_only: consolidated_only) do |message|
        puts message
        response.stream.write message
      end
    ensure
      response.stream.close
    end

  end
end