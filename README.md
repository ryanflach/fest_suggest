# FestSuggest
[![Code Climate](https://codeclimate.com/github/ryanflach/fest_suggest/badges/gpa.svg)](https://codeclimate.com/github/ryanflach/fest_suggest) [![Stories in Ready](https://badge.waffle.io/ryanflach/fest_suggest.svg?label=ready&title=Ready)](http://waffle.io/ryanflach/fest_suggest)

**Live Demo: http://www.festsuggest.com**

## About
A website for [Spotify](www.spotify.com) users to find upcoming music festivals based on their listening habits.

After querying the Spotify API and pulling the user's top and recommended artists by all time, the past six months, or the past four weeks, the app ties in with the [Songkick](www.songkick.com) API to identify upcoming events for each top artist with dates scheduled. The app then filters down to only upcoming festivals and performs analysis to rank the upcoming festivals, based on the number of top and recommended artists at each festival, as well as the ranking of those top artists. When analysis is complete, the top festivals are returned and ranked in order, up to five.

## Usage
After cloning or forking the project, bundle:
```
bundle
```
and initialize the database:
```
rake db:{create,migrate}
```
Launch a server
```
rails s
```
Explore.

_API keys are required for both Spotify and Songkick. You can find more information on the Spotify API [here](https://developer.spotify.com/web-api/), and the Songkick API [here](http://www.songkick.com/developer). Both are well documented._

_Please note that, in the application's default state, [redis](https://github.com/redis-store/redis-rails) is required to enable caching._
