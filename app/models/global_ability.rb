class GlobalAbility < Ability
  def initialize user
    @user = user
    load_roles
    cache_roles
  end

  protected

  def load_roles
    @roles = @user.roles
  end
end