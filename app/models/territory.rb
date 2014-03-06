class Territory < ActiveRecord::Base
  belongs_to :environment

  has_many :territory_scopes
  accepts_nested_attributes_for :territory_scopes
end
