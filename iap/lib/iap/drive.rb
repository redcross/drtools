module Iap
  class Drive

    class InvalidToken < Exception; end

    attr_reader :client
    def initialize(client)
      @client = client
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
      result = client.execute(
        :api_method => drive.files.get,
        :parameters => { 'fileId' => file_id })
      raise InvalidToken if result.status == 401
      JSON.parse result.response.body
    end

    def list_folders()
      result = client.execute(
        :api_method => drive.files.list,
        :parameters => { 'q' => "'root' in parents and mimeType = \"application/vnd.google-apps.folder\" and trashed = false"})
      raise InvalidToken if result.status == 401
      JSON.parse result.response.body
    end

    def list_folder(folder_id)
      result = client.execute(
        :api_method => drive.files.list,
        :parameters => { 'q' => "'#{folder_id}' in parents and trashed = false" })
      raise InvalidToken if result.status == 401
      JSON.parse result.response.body
    end

    def download_file(file)
        result = client.execute(:uri => file)
        raise InvalidToken if result.status == 401
        if result.status == 200
          return result.response.body
        elsif result.status == 302
          return download_file(client, result.response.headers['location'])
        else
          puts "An error occurred: #{result.data['error']['message']}"
          return nil
        end
    end

  end
end