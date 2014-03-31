class RootController < ApplicationController
  def index

  end

  protected

  def current_ability
    @ability ||= GlobalAbility.new current_user
  end
end