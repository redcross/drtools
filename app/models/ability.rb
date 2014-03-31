class Ability
  def role? *list
    search_roles list.flatten, true
  end

  def role_exactly? *list
    search_roles list.flatten, false
  end

  def search_roles list, allow_admin=true
    Rails.logger.info "Looking for #{list.inspect} in #{@role_cache.inspect}"
    list.compact.any? do |name_or_object|
      value = (Role === name_or_object ? name_or_object.value : name_or_object)
      role = name_or_object if Role === name_or_object

      (allow_admin && (admin? || (role && admin?(role.component)))) || @role_cache.key?(value)
    end
  end

  def admin? component=nil
    value = [component, "admin"].compact.join "_"
    @role_cache.key? value
  end

  protected

  def cache_roles
    @role_cache = @roles.reduce({}){|h, r| h.store(r.value, r); h }
  end
end