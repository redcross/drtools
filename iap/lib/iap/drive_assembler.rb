module Iap
  class DriveAssembler
    attr_reader :client, :files
    def initialize(drive_client, files)
      @client = drive_client
      @files = files
    end

    def assemble
      dir = Dir.mktmpdir

      default_opts = "&printtitle=false&fitw=true&gridlines=false"

      # Download the individual PDFs
      pdfs = @files.each_with_index.map do |file, idx|
        desc = file['description'] || ''
        next if desc =~ /NOPRINT/

        if file['exportLinks']
          url = file['exportLinks']['application/pdf']
          if file['mimeType'] == 'application/vnd.google-apps.spreadsheet'
            url << default_opts
            if desc =~ /LANDSCAPE/
              url << '&portrait=false'
            else
              url << '&portrait=true'
            end
          end
        else
          url = file['downloadUrl']
        end

        filename = File.join(dir, "download#{'%02d' % idx}.pdf")

        [filename, url]
      end

      threads = pdfs.map do |filename, url|
        Thread.new do
          File.open(filename, "wb") do |f|
            f.write client.download_file(url)
          end
        end
      end
      
      threads.each(&:join)

      # Merge the PDFs
      out_filename = File.join(dir, "out.pdf")
      PdfMerger.new.merge(pdfs.map(&:first), out_filename)

      if block_given?
        File.open out_filename, "r" do |f|
          return yield(f)
        end
      else
        return File.read out_filename
      end

    ensure
      FileUtils.remove_entry_secure dir if dir
    end
  end
end