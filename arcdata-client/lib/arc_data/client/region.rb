class ARCData::Client
  class Region
    def initialize(client)
      @client = client
    end

    def get id
      @client.get "/api/chapters/#{id}.json"
    end
  end
end