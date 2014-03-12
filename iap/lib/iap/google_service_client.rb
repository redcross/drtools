module Iap
  module GoogleServiceClient
    def self.client user_email
      key = Google::APIClient::PKCS12.load_key(service_account_key, 'notasecret')
      asserter = Google::APIClient::JWTAsserter.new(service_account_email, 'https://www.googleapis.com/auth/drive', key)
      
      Google::APIClient.logger.level = Logger::DEBUG
      Google::APIClient.new(application_name: 'DRTools', application_version: '0').tap do |client|
        client.authorization = asserter.authorize(user_email)
      end
    end

    def self.service_account_email
      ENV['GOOGLE_SERVICE_ACCOUNT_ID']
    end

    def self.service_account_key
      Base64.decode64 ENV['GOOGLE_SERVICE_ACCOUNT_KEY']
    end
  end
end