module Iap
  class Recipient < ActiveRecord::Base
    belongs_to :environment

    assignable_values_for :recipient_type do
      %w(internal external leadership)
    end
  end
end
