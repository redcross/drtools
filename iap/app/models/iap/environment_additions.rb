module Iap
  module EnvironmentAdditions
    extend ActiveSupport::Concern

    included do
      has_many :plans, class_name: 'Iap::Plan'
      has_many :recipients, class_name: 'Iap::Recipient'
    end
  end
end