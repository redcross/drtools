module Iap
  class Drive

    class InvalidToken < Exception; end

    MIME_FOLDER = "application/vnd.google-apps.folder"

    attr_reader :client
    def initialize(client)
      @client = client
      @client.retries = 3
    end

    def parse_result result
      case result.status
      when 401 then raise InvalidToken.new(error_message result)
      when 200, 201, 204 then result.data
      else raise error_message(result)
      end
    end

    def error_message result
      result.data['error']['message']
    end

    def execute *args
      parse_result client.execute(*args)
    end

    def discovery_document
      Rails.cache.fetch("DriveV2", expires_in: 1.hour) do
        resp = HTTParty.get "https://www.googleapis.com/discovery/v1/apis/drive/v2/rest"
        resp.body
      end
    end

    def drive
      Rails.cache.fetch("DriveV2_Parsed", expires_in: 1.hour) do
        client.discovered_api('drive', 'v2')
      end
    end

    def get_file(file_id)
      parse_result client.execute(
        :api_method => drive.files.get,
        :parameters => { 'fileId' => file_id })
      
    end

    def list_folders()
      parse_result client.execute(
        :api_method => drive.files.list,
        :parameters => { 'q' => "'root' in parents and mimeType = \"application/vnd.google-apps.folder\" and trashed = false"})
    end

    def list_folder(folder_id)
      parse_result client.execute(
        :api_method => drive.files.list,
        :parameters => { 'q' => "'#{folder_id}' in parents and trashed = false" })
    end

    def download_file(file)
      result = client.execute(:uri => file)
      raise InvalidToken if result.status == 401
      case result.status
      when 200 then result.response.body
      when 302 then download_file(client, result.response.headers['location'])
      else
        puts "An error occurred: #{result.data['error']['message']}"
        nil
      end
    end

    def create_folder(parent_ids, name)
      file = drive.files.insert.request_schema.new({
        'title' => name,
        'mimeType' => MIME_FOLDER
      })
      # Set the parent folder.
      if parent_ids.present?
        file.parents = Array(parent_ids).map{|parent_id| {'id' => parent_id}}
      end
      parse_result client.execute(
        :api_method => drive.files.insert,
        :body_object => file)
    end

    def copy_file(origin_file_id, copy_title, parent_id)
      drive = client.discovered_api('drive', 'v2')
      copied_file = drive.files.copy.request_schema.new({
        'title' => copy_title,
        'parents' => [{'id' => parent_id}]
      })
      parse_result client.execute(
        :api_method => drive.files.copy,
        :body_object => copied_file,
        :parameters => { 'fileId' => origin_file_id })
    end

    def share_to file_id, role, type, id
      new_permission = drive.permissions.insert.request_schema.new({
        'value' => id,
        'type' => type,
        'role' => role
      })
      parse_result client.execute(
        :api_method => drive.permissions.insert,
        :body_object => new_permission,
        :parameters => { 'fileId' => file_id, 'sendNotificationEmails' => false })
    end
  end
end