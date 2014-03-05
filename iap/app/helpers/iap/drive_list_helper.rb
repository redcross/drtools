module Iap
  module DriveListHelper
    def content_type_mapping mime_type
      case mime_type
      when 'application/pdf' then "PDF"
      when 'application/vnd.google-apps.document' then "Word Processing"
      when 'application/vnd.google-apps.spreadsheet' then "Spreadsheet"
      when 'application/vnd.google-apps.folder' then "Folder"
      when 'application/vnd.google-apps.fusiontable' then "Fusion Table"
      when 'application/vnd.google-apps.form' then 'Google Form'
      when 'application/vnd.google-earth.kml+xml' then 'KML'
      when 'application/vnd.google-earth.kmz' then 'KMZ'
      when 'application/vnd.google-apps.presentation' then 'Presentation'
      when 'application/vnd.google-apps.drawing' then 'Drawing'
      else mime_type
      end
    end
  end
end