module Iap
  module DriveAssembleHelper
    def thumbnail_link file
      link = file['thumbnailLink'].dup
      link << (link.include?("?") ? "&" : "?") << "access_token=" << access_token
    end
  end
end