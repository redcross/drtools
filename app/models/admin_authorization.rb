class AdminAuthorization < ActiveAdmin::AuthorizationAdapter
  
  def authorized? action, subject=nil
    return true if Class === subject

    env = environment_for_subject(subject)
    ability = env ? ability_for_environment(env) : GlobalAbility.new(user)
    #pp subject, ability.to_s
    ability.role? Roles::CONFIGURE_ENVIRONMENT
  end

  def scope_collection collection, action = Auth::READ
    collection
  end

  def environment_for_subject subject
    case subject
    when NilClass then nil
    when Environment then subject
    when UserEnvironment, RegionEnvironment, Territory, TerritoryScope, GAPPermission then subject.environment
    end
  end

  def ability_for_environment env
    @abilities ||= Hash.new
    @abilities[env] ||= EnvironmentAbility.new env, user
  end
end