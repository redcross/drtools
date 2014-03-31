class ARCData::Client
  module Base
    extend ActiveSupport::Concern

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

    module ClassMethods
      def oauth_client
        @auth_client ||= begin
          Rack::OAuth2::Client.new identifier: ARCData::Client::Config.client_id,
                                   secret: ARCData::Client::Config.client_secret,
                                   authorization_endpoint: ARCData::Client::Config.base_url+"/openid/authorizations/new",
                                   token_endpoint: ARCData::Client::Config.base_url+"/openid/access_tokens"
        end
      end

      def client_credentials
        @global_client ||= begin
          token = oauth_client.access_token!.access_token
          self.new token
        end
      end
    end
  end
end