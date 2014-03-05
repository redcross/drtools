class Users::CallbacksController < Devise::OmniauthCallbacksController
  def arcdata
    auth = request.env['omniauth.auth']
    user = UserLogin.new(auth).login!

    sign_in_and_redirect user, event: :authentication
  end
end