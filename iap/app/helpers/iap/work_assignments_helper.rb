module Iap
  module WorkAssignmentsHelper
    def person_datasource_url
      uri = ENV['ARCDATA_OPENID_URL'] || "http://9ddc583f03581f709784cd1416ed6656:d3aa82a369f8521de6e9c7ada47683e88fb21d098a6ba7b545929c4ed4ff34bc@localhost:3000"
      uri = URI.parse uri
      uri.path = '/api/people'
      uri.user = uri.password = nil;
      uri.query = {access_token: current_user.token}.to_query
      uri.to_s
    end
  end
end
