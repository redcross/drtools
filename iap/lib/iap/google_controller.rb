module Iap
  module GoogleController
    extend ActiveSupport::Concern

    SESSION_OAUTH_CREDENTIALS = 'Iap::GoogleAccessToken'
    SESSION_OAUTH_USER = 'Iap::GoogleUser'
    SESSION_RETURN_URL = 'Iap::GoogleLoginReturn'

    included do
      rescue_from Drive::InvalidToken do
        logout_google!
        authenticate_oauth!
      end

      helper_method :oauth_user, :access_token
    end

    def callback
      auth = request.env['omniauth.auth']
      session[SESSION_OAUTH_CREDENTIALS] = auth['credentials']
      session[SESSION_OAUTH_USER] = auth['info']['email']
      redirect_to session.delete(SESSION_RETURN_URL || "")
    end

    def switch_user
      logout_google!
      authenticate_oauth! params[:return_to]
    end

  protected
    def authenticate_oauth!(return_to = nil)
      return if request.env['omniauth.auth']
      if oauth_credentials.nil? || token_expired?
        session[SESSION_RETURN_URL] = return_to || request.original_url
        redirect_to "/auth/#{Engine::IAP_OMNIAUTH_NAME}"
      end
    end

    def logout_google!
      session.delete SESSION_OAUTH_CREDENTIALS
      session.delete SESSION_OAUTH_USER
    end

    def oauth_user
      session[SESSION_OAUTH_USER]
    end

    def api_client
      return @api_client if @api_client

      @api_client = Google::APIClient.new application_name: 'DRTools', 
                                       application_version: '0'

      @api_client.authorization.access_token = self.access_token
      
      @api_client                                
    end

    def oauth_credentials
      session[SESSION_OAUTH_CREDENTIALS]
    end

    def access_token
      oauth_credentials && oauth_credentials['token']
    end

    def token_expired?
      if credentials = oauth_credentials
        credentials['expires']!=false && credentials['expires_at'] <= Time.now.to_i
      end
    end

    def drive
      @drive ||= Drive.new(api_client)
    end
  end
end