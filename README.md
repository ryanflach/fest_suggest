# FestSuggest
[![Code Climate](https://codeclimate.com/github/ryanflach/fest_suggest/badges/gpa.svg)](https://codeclimate.com/github/ryanflach/fest_suggest) [![Stories in Ready](https://badge.waffle.io/ryanflach/fest_suggest.svg?label=ready&title=Ready)](http://waffle.io/ryanflach/fest_suggest)

**Live Site: http://www.festsuggest.com**

## About
A website for [Spotify](www.spotify.com) users to find upcoming music festivals based on their listening habits. Technologies used include Rails, JavaScript, jQuery, Redis, and Sidekiq.

## Functionality
A user is able to:
- View their top artists based on their listening habits from the last 4 weeks, the last 6 months, or all time.
- View up to 5 recommended upcoming music festivals per above time frame of listening habits
  - View which top and recommended artists are appearing at the festival
  - View how many other artists are on the festival line-up
  - Follow a hyperlink to the full line-up and additional details on Songkick
  - Follow or unfollow a Spotify playlist that contains the top track of up to 100 artists on the festival line-up

## How it Works
After querying the Spotify API and pulling the user's top and recommended artists by all time, the past six months, or the past four weeks, the app ties in with the [Songkick](www.songkick.com) API to identify upcoming events for each top artist with dates scheduled. The app then filters down to only upcoming festivals and performs analysis to rank the upcoming festivals, based on the number of top and recommended artists at each festival, as well as the ranking of those top artists. When analysis is complete, the top festivals are returned and ranked in order, up to five.

Playlists are created on an as-needed basic through a Spotify account that belongs to the site. Once the first user interested in a playlist clicks on 'Follow', the playlist is created and it appears in the user's followed playlists on Spotify. A background worker is then triggered to fetch the top track for up to 100 artists at the festival, eventually adding them to the playlist. This process is not required for subsequent users to follow, as the playlist has already been created and its tracks added.

## Repo Usage
After cloning or forking the project, bundle:
```
bundle
```
and initialize the database:
```
rake db:{create,migrate}
```

_Note: API keys are required for both Spotify and Songkick. You can find more information on the Spotify API [here](https://developer.spotify.com/web-api/), and the Songkick API [here](http://www.songkick.com/developer). Both are well documented._

Launch a server
```
rails s
```
Explore.

_Please note that, in the application's default state, [redis](https://github.com/redis-store/redis-rails) is required to enable caching, and [Sidekiq](https://github.com/mperham/sidekiq) is required to enable the processing of background jobs via a worker._
