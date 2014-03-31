module HasRoles
  extend ActiveSupport::Concern

  def role_strings= vals
    write_attribute :roles, Array(vals).select(&:present?)
  end

  def role_strings
    read_attribute(:roles)
  end

  def roles
    Array(role_strings).map{|str| Roles[str] || str }
  end

  def roles_string
    Array(roles).map{|r| r.try(:label) || r }.join ","
  end
end