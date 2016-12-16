desc "This task is called by the Heroku scheduler add-on"
task :renew_token => :environment do
  puts "Renewing site admin tokens..."
  UserEngine.update_user(User.site_admin)
  puts "done."
end
