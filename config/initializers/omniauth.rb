#Rails.application.config.middleware.use OmniAuth::Builder do  
#  #provider :arcdata, 'ebd9f6921bf263af08d86d3ef46e6aa2', '00083eab359e319953d5662dc4f8675b'  
#  provider :openid_connect, {
#    identifier: '9ddc583f03581f709784cd1416ed6656',
#    secret: 'd3aa82a369f8521de6e9c7ada47683e88fb21d098a6ba7b545929c4ed4ff34bc',
#    scheme: 'http',
#    host: 'localhost',
#    port: '3000',
#    authorization_endpoint: '/openid/authorizations/new',
#    token_endpoint: '/openid/access_token',
#    userinfo_endpoint: '/openid/user_info'
#  }
#end