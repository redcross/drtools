class ARCData::Client
  class Person
    def initialize(client)
      @client = client
    end

    def get_person
      @client.get '/api/people/me.json'
    end
  end
end