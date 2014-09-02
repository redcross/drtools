module Roles

  def self.register *args
    register_role Role.new(*args)
  end

  def self.register_role role
    role.freeze

    add_role role
    register_constant role
  end

  def self.[] name
    roles_by_value[name]
  end

  private

  def self.roles_by_value
    @roles_by_value ||= Hash.new
  end

  def self.roles
    @roles ||= Array.new
  end

  def self.add_role role
    roles << role
    roles_by_value[role.value] = role
  end

  def self.register_constant role
    component = role.component.to_s.titleize
    name = role.name.to_s.upcase
    unless component.blank? || self.const_defined?(component, false)
      self.const_set(component, Module.new) 
      const_name = "#{self.to_s}::#{component}" 
    end
    container = component.present? ? const_get(component) : self
    container.const_set name, role
  end

  register nil, :admin
  register nil, :configure_environment
  register nil, :assigned_staff
  ActiveSupport.run_load_hooks :roles, self
end