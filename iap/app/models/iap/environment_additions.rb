module Iap
  module EnvironmentAdditions
    extend ActiveSupport::Concern

    included do
      has_many :plans, class_name: 'Iap::Plan'
    end
  end
end