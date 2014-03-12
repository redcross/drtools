module Iap
  class TemplateCreator
    def initialize(api_client, owner_id)
      @api_client = api_client
      @owner_id = owner_id
    end

    def create(parent_folder, new_name)
      @parent_folder_id = parent_folder

      template_files = drive_service.list_folder template_folder_id
      template_folder = drive_service.get_file template_folder_id

      @new_folder = drive_service.create_folder [template_folder['parents'].first['id']], new_name
      drive_service.share_to @new_folder['id'], 'writer', 'user', @owner_id
      drive_service.share_to @new_folder['id'], 'writer', 'domain', 'sitcell.org'

      template_files['items'].map do |file|
        Thread.new do
          copy_and_share file
        end
      end.map(&:join)
    end

    def copy_and_share file
      title = file['title']
      new_file = drive_service.copy_file file['id'], title, @new_folder['id']
    end

    def drive_service
      @drive_service ||= Drive.new service_client
    end

    def drive_user
      @drive_user ||= Drive.new @api_client
    end

    def service_client
      @service_client ||= GoogleServiceClient.client template_owner
    end

    def template_owner
      ENV['IAP_TEMPLATE_OWNER']
    end

    def template_folder_id
      ENV['IAP_TEMPLATE_ID']
    end
  end
end