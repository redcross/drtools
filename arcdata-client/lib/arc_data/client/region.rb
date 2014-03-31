class ARCData::Client
  class Region
    attr_reader :client
    def initialize(client)
      @client = client
    end

    def list
      client.get("/api/chapters.json").map{|attrs| Hashie::Mash.new attrs }
    end

    def get id
      attrs = client.get "/api/chapters/#{id}.json"
      Hashie::Mash.new attrs
    end
  end
end