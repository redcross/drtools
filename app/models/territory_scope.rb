class TerritoryScope < ActiveRecord::Base
  belongs_to :territory

  assignable_values_for :scope_type do
    %w(consolidated chapter county)
  end
end
