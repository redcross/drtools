module Iap
  class DriveAssembleController < ApplicationController
    include GoogleController
    before_filter :authenticate_oauth!
    helper DriveListHelper
    inherit_resources
    defaults resource_class: PlanAttachment, route_prefix: nil, collection_name: 'plan_attachments'
    belongs_to :environment, finder: :find_by_slug!
    belongs_to :plan, finder: :find_by_number!

    before_filter :require_draft_plan

    def create
      build_resource
      resource.valid?
      if resource.errors.none? {|k, errors| k != :file}
        if is_regular_file?
          make_pdf [file]
        else
          make_pdf files
        end
      else
        super
      end
    end

    protected

    def require_draft_plan
      if parent.approved?
        flash[:error] = "This IAP is approved and cannot be edited."
        redirect_to parent_path
      end
    end

    def make_pdf files
      DriveAssembler.new(drive, files).assemble do |file|
        filename = "#{build_resource.title}.pdf"
        build_resource.file = file
        build_resource.file.instance_write(:file_name, filename)
        create! { environment_plan_path(*association_chain) }
      end
    end

    helper_method :files, :file, :is_regular_file?

    def files
      @files ||= begin
        items = drive.list_folder(params[:folder_id])['items']
        items.sort_by!{|f| f['title']}
        items.select{|f| f['mimeType'] != "application/vnd.google-apps.folder" }
      end
    end

    def file
      @file ||= drive.get_file params[:folder_id]
    end

    def is_regular_file?
      file['mimeType'] != "application/vnd.google-apps.folder"
    end

    def build_resource
      @plan_attachment ||= super.tap do |att|
        att.title ||= file['title']
      end
    end

    def build_resource_params
      [params.fetch(:plan_attachment, {}).permit(:title, :audience, :attachment_type)]
    end
  end
end