class GetAssignedStaffJob
  attr_reader :client
  attr_reader :environment
  def initialize(source_client, environment)
    @client = Vc::QueryTool.from_client source_client
    @environment = environment
  end

  def perform
    id = environment.vc_incident_number
    raise "Incident has no VC Id" unless id.present?

    client.set_incident_id id

    load_member_number_hash

    resp = client.get_disaster_query '57201', {prompt0: id, reference: 'disaster'}, :csv
    data = CSV.parse resp.body

    data.uniq!{ |row| row[17] } # Dedup based on name

    to_import = []
    data.each do |row|
      member_number = @member_numbers[row[16]]
      to_import << AssignedStaff.new(environment_id: environment.id, member_number: member_number, name: row[17], home_phone: row[24], work_phone: row[25], cell_phone: row[26], email: row[29], gap: row[30])
    end

    AssignedStaff.transaction do
      AssignedStaff.where{environment_id == my{environment}}.delete_all
      AssignedStaff.import to_import
    end

    nil
  end

  def load_member_number_hash
    @member_numbers = {}
    resp = client.get_disaster_query '47133', {prompt0: environment.vc_incident_number, prompt1: 'All', prompt2: 'All', prompt3: 'All'}, :csv

    data = CSV.parse resp.body
    data.each do |row|
      @member_numbers[row[12]] = row[11]
    end
  end
end