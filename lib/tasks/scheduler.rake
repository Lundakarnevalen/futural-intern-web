desc 'Tasks for Heroku scheduler'
task :podio_sync => :environment do
  unless PodioSync.perform_sync
    PodioSyncMailer.sync_fail(PodioSync.last_log).deliver
  end
end

task :send_karneblocket_reminders => :environment do
  listings = TicketListing.to_remind
  failures = {}

  if listings.empty?
    puts 'No reminders to be sent; exiting'
  else
    listings.each do |tl|
      begin
        KarneblocketMailer.remind! tl
      rescue Exception => e
        puts "Delivery to #{tl.seller.email} fails"
        puts "  #{e.to_s}"
        failures[tl] = e
      else
        puts "Delivered reminder to #{tl.seller.email}"
      end
    end
  end

  if failures.any?
    puts 'Mailing failure details to system'
    KarneblocketMailer.reminder_fail(failures).deliver
  end
end

