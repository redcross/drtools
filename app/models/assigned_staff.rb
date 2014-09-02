class AssignedStaff < ActiveRecord::Base
  belongs_to :environment
  self.table_name = :assigned_staff

  has_one :staff_contact_override, foreign_key: :vc_member_number, primary_key: :member_number

  delegate :email_override, :phone_override, to: :staff_contact_override, allow_nil: true

  def self.name_contains query
    where{name.like "%#{query}%"}
  end

  def primary_email
    staff_contact_override.try(:email_override) || email
  end

  def primary_phone
    staff_contact_override.try(:phone_override) || cell_phone || home_phone || work_phone
  end

  def primary_email= new_email
    build_staff_contact_override unless staff_contact_override
    staff_contact_override.email_override = new_email
  end

  def primary_phone= new_phone
    build_staff_contact_override unless staff_contact_override
    staff_contact_override.phone_override = new_phone
  end
end
