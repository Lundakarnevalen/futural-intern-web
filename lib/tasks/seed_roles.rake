desc 'Seed the database with the current role table.'
task :seed_roles => :environment do
  Role.seed_roles
end

