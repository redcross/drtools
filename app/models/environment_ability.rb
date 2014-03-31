class EnvironmentAbility < Ability
  def initialize environment, user
    @environment = environment
    @user = user

    load_roles
    cache_roles
  end

  private

  def load_roles
    @roles = [user_roles, direct_roles, region_roles, gap_roles].compact.flatten
  end

  def user_roles
    @user.roles
  end

  def direct_roles
    UserEnvironment.for_user_environment(@user, @environment).flat_map(&:roles)
  end

  def region_roles
    # This isn't complete yet, need to store roles from the person object during login
    if @user.region_id && mapping = RegionEnvironment.find_by(region_id: @user.region_id, environment_id: @environment.id)
      []
    end
  end

  def gap_roles
    []
  end

end