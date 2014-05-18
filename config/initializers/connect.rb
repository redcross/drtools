
OpenIDConnect.logger = WebFinger.logger = SWD.logger = Rack::OAuth2.logger = Rails.logger
if Rails.env.development?
  OpenIDConnect.debug!

  SWD.url_builder = WebFinger.url_builder = URI::HTTP
end
