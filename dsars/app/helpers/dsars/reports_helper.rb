module Dsars
  module ReportsHelper
    def format val, type
      case type
      when 'currency'
        number_to_currency val, precision: 0
      else
        number_with_delimiter val
      end
    end
  end
end