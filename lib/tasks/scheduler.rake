desc 'Sync the local database with Podio'
task :podio_sync => :environment do
  unless PodioSync.perform_sync
    PodioSyncMailer.sync_fail(PodioSync.last_log)
  end
end

