# desc "Explaining what the task does"
# task :dsars do
#   # Task goes here
# end
namespace :dsars do
  desc "Downloads updated reports for any active environment"
  task :update_disasters => :environment do
    envs = Environment.active.with_enable_dsars_value(true).where{dsars_incident_number != nil}.select{|env| env.dsars_incident_number.present?}
    importer = Dsars::Importer.new ENV['DSARS_USERNAME'], ENV['DSARS_PASSWORD']
    envs.each do |env|
      importer.import(env.dsars_incident_number)
    end
  end
end