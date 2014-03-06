namespace :dsars do
  desc "Load views from SQL"
  task :update_views => :environment do
    views = Dir["#{Dsars::Engine.config.root}/db/views/*.sql"].sort
    views.each do |v|
      sql = File.read v
      ActiveRecord::Base.connection.execute sql
    end
  end

  namespace :db do
    desc "Load seeds"
    task :seed => :environment do
      Dsars::Engine.load_seed
    end
  end
end