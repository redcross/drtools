module Sitreps
  class Response < ActiveRecord::Base
    belongs_to :sitrep
    validates :title, :ordinal, :response, presence: true
  end
end
