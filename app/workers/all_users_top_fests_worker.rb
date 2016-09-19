# class AllUsersTopFestsWorker
#   include Sidekiq::Worker
#
#   def perform
#     User.all.each do |user|
#       current_time = Time.now
#       params = {
#         user: user,
#         token: user.access_token,
#         time: current_time
#       }
#
#       update_cached_festivals(params, 'long_term')
#       update_cached_festivals(params, 'medium_term')
#       update_cached_festivals(params, 'short_term')
#
#       user.update(cache_updated: Time.now)
#     end
#   end
#
#   private
#
#   def update_cached_festivals(params, range)
#     Rails.cache.write(
#       "#{params[:user].id}-top_festivals_#{range}-#{params[:time]}",
#       expires_in: 2.hours
#     ) do
#       artists = Artists.all(params[:token], range)
#       Festival.top_festivals(artists)
#     end
#     Rails.cache.delete(
#       "#{params[:user].id}-top_festvials_" \
#       "#{range}-#{params[:user].cache_updated}"
#     )
#   end
# end
