module ARCData
  class Client
    module Config
      mattr_accessor :base_url, :client_id, :client_secret

      def self.base_uri
        URI.new base_url
      end
    end

    def self.configure &block
      Config.instance_exec &block
    end

    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Person
    autoload :Version
    autoload :Region

    include Base

    def person
      @person ||= Person.new(self)
    end

    def region
      @region ||= Region.new(self)
    end

  end
end