module Iap
  class DriveListController < ApplicationController
    include GoogleController

    before_filter :authenticate_oauth!
    skip_before_filter :add_breadcrumbs!, except: :index
    before_filter :require_draft_plan, only: :index
    before_filter :authorize_producer!, only: :index

    MIME_FOLDER = "application/vnd.google-apps.folder"

    def index
      params[:folder_id] ||= 'root'

      @folder = drive.get_file params[:folder_id]
      items = drive.list_folder(params[:folder_id])['items']
      items.sort_by!{|f| f['title']}

      @folders = items.select{|f| f['mimeType'] == MIME_FOLDER }
      @files = items.reject{|f| f['mimeType'] == MIME_FOLDER }
    end

    protected

    def require_draft_plan
      if parent.approved?
        flash[:error] = "This IAP is approved and cannot be edited."
        redirect_to parent_path
      end
    end

    helper_method :environment, :parent
    def environment
      @environment ||= Environment.find_by_slug! params[:environment_id]
    end

    def parent
      @parent ||= environment.plans.find_by_number! params[:plan_id]
    end

    def parent_path
      environment_plan_path(environment, parent)
    end

    helper_method :list_folder_path, :assemble_path, :parent_folder_path
    def list_folder_path(folder_id)
      url_for folder_id: folder_id
    end

    def assemble_path(item_id=nil)
      item_id ||= params[:folder_id]
      url_for folder_id: item_id, controller: 'drive_assemble', action: 'new'
    end

    def parent_folder_path
      url_for folder_id: parent_folder_id
    end

    def parent_folder_id
      (ref = @folder['parents'].first ) && ref['id']
    end

    def add_breadcrumbs
      breadcrumb "IAP", environment_plans_path(environment)
      breadcrumb parent.to_breadcrumb, environment_plan_path(environment, parent)
      breadcrumb "New Attachment"
    end

    helper_method :is_valid
    def is_valid(f)
      f['mimeType'] == 'application/pdf' ||
      (f['exportLinks'] && f['exportLinks']['application/pdf'])
    end

    helper_method :all_valid
    def all_valid
      @files.all?{|f| is_valid(f)}
    end

    def auth_hash
      request.env['omniauth.auth']
    end

    def drive
      @drive ||= Drive.new(api_client)
    end
  end
end