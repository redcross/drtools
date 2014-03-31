module Iap
  module DriveAssembleHelper
    def thumbnail_link file
      if link = file['thumbnailLink']
        link = link.dup
        link << (link.include?("?") ? "&" : "?") << "access_token=" << access_token
      end
    end
  end
end