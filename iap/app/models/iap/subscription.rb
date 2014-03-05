module Iap
  class Subscription < ActiveRecord::Base
    belongs_to :environment
    belongs_to :user
  end
end
