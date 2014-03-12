module Iap
  class TemplateController < ApplicationController
    include GoogleController
    before_filter :authenticate_oauth!

    def new
      params[:folder_id] ||= 'root'

      @folder = drive.get_file params[:folder_id]
      items = drive.list_folder(params[:folder_id])['items']
      items.sort_by!{|f| f['title']}

      @folders = items.select{|f| f['mimeType'] == Drive::MIME_FOLDER }
    end

    def create
      creator = TemplateCreator.new api_client, oauth_user
      creator.create params[:folder_id], params[:iap_folder_name]

      flash[:notice] = "The template folder was created in Google Drive"
      redirect_to environment_plans_path params[:environment_id]
    end

    protected

    def add_breadcrumbs

    end

    helper_method :environment
    def environment
      @environment ||= Environment.find_by_slug! params[:environment_id]
    end

    helper_method :list_folder_path, :assemble_path, :parent_folder_path
    def list_folder_path(folder_id)
      url_for folder_id: folder_id
    end

    def parent_folder_path
      url_for folder_id: parent_folder_id
    end

    def parent_folder_id
      (ref = @folder['parents'].first ) && ref['id']
    end
  end
end