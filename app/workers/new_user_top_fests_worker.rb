# class NewUserTopFestsWorker
#   include Sidekiq::Worker
#
#   def perform(user_id)
#     user = User.find(user_id)
#     current_time = Time.now
#     params = {
#       user: user,
#       token: user.access_token,
#       time: current_time
#     }
#     create_cached_festivals(params, 'long_term')
#     create_cached_festivals(params, 'medium_term')
#     create_cached_festivals(params, 'short_term')
#   end
#
#   private
#
#   def create_cached_festivals(params, range)
#     artists = Artist.all(params[:token], range)
#     festivals = Festival.top_festivals(artists)
#
#     Rails.cache.write(
#       "#{params[:user].id}-top_festivals_#{range}-#{params[:time]}",
#       festivals,
#       expires_in: 2.hours
#     )
#     params[:user].update(cache_updated: params[:time])
#   end
# end
