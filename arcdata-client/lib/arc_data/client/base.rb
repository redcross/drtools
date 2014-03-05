class ARCData::Client
  module Base
    def initialize(token)
      @bearer = token
    end

    def client
      @client ||= Rack::OAuth2::AccessToken::Bearer.new(access_token: @bearer)
    end

    def base_url
      ARCData::Client::Config.base_url
    end

    def get path
      response = client.get base_url+path
      parse_response response
    end

    def post path, params
      response = client.post base_url+path, params
      parse_response response
    end

    def parse_response response
      JSON.parse response.body
    end
  end
end