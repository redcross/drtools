task :get_assigned_staff => :environment do
  Raven.capture do
    client = Vc::Client.new ENV['VC_USERNAME'], ENV['VC_PASSWORD']
    client.login!
    Environment.active.each do |env|
      next unless env.vc_incident_number.present?
      GetAssignedStaffJob.new(client, env).perform
    end
  end

end