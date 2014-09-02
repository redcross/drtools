class StaffContactOverride < ActiveRecord::Base
  belongs_to :assigned_staff, foreign_key: :vc_member_number, primary_key: :member_number
end
