module Sitreps
  class Prompt < ActiveRecord::Base
    belongs_to :config
    validates :title, presence: true
  end
end
