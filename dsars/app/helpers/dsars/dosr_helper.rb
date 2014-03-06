module Dsars
  module DosrHelper
    def sparkline_image_url data
      min, max = data.minmax
      delta = max-min
      min -= delta * 0.05
      max += delta * 0.05
      Gchart.sparkline  size: '300x25', data: data, use_ssl: true, 
                        min_value: min, max_value: max, 
                        bg: "00000000", 
                        line_colors: "6D6E70",
                        new_markers: "o,ED1B2E,0,-1:-1:1,5,1", 
                        custom: "chma=0,5,0,0"
    end

  end
end