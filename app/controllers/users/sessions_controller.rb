
class Users::SessionsController < Devise::SessionsController

  def new
    #redirect_to user_omniauth_authorize_path(:arcdata)
  end

  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield resource if block_given?

    if signed_out
      redirect_path = base_signout_url(root_url + redirect_path.gsub(/^\//, ''))
    end

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

  protected

  def base_signout_url(next_redirect)
    uri = ENV['ARCDATA_OPENID_URL'] || 'http://localhost:3000'
    uri = URI.parse uri
    uri.user = uri.password = nil
    uri.path = '/openid/logout'
    uri.query = {post_logout_redirect_uri: next_redirect}.to_query
    uri.to_s
  end

end