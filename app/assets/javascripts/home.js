$(document).ready(function(){
  allTimeArtistsButton();
  sixMonthArtistsButton();
  fourWeekArtistsButton();
  allTimeFestButton();
  sixMonthFestButton();
  fourWeekFestButton();
  $('#all-time-button').click();
  hideInitialElements();
});

function hideInitialElements(){
  $('#top-festivals').hide();
  $('#progress-bar').hide();
  $('#loading-status').hide();
}

function loadingBar(){
  $('#top-festivals').hide();
  $('.progress-bar').attr('aria-valuenow', 5).css('width', '5%');
  $('#progress-bar').fadeIn('fast');
  $('#loading-status').hide().html('Gathering recommended artists from Spotify based on your selected top artists...').fadeIn('slow');
  loadingStageOne = setTimeout(theWheelsAreInMotion, 5000);
}

function theWheelsAreInMotion(){
  $('.progress-bar').attr('aria-valuenow', 30).css('width', '30%');
  $('#loading-status').hide().html('Gathering Songkick data for each of your top artists...').fadeIn('slow');
  loadingStageTwo = setTimeout(sweetProgress, 6000);
}

function sweetProgress(){
  $('.progress-bar').attr('aria-valuenow', 55).css('width', '55%');
  $('#loading-status').hide().html('Determining which top artists have upcoming festivals...').fadeIn('slow');
  loadingStageThree = setTimeout(finalCountdown, 7000);
}

function finalCountdown(){
  $('.progress-bar').attr('aria-valuenow', 80).css('width', '80%');
  $('#loading-status').hide().html('Analyzing results...').fadeIn('slow');
}

function allTimeFestButton(){
  $('#all-time-fest-button').on('click', function(event){
    event.preventDefault();
    $('#top-fests-header').hide().html('Top 5 Upcoming Festivals - All Time Top Artists').fadeIn('slow');
    loadingBar();
    fetchFestivals('long_term');
  });
}

function sixMonthFestButton(){
  $('#6-mo-fest-button').on('click', function(event){
    event.preventDefault();
    $('#top-fests-header').hide().html('Top 5 Upcoming Festivals - 6 Month Top Artists').fadeIn('slow');
    loadingBar();
    fetchFestivals('medium_term');
  });
}

function fourWeekFestButton(){
  $('#4-week-fest-button').on('click', function(event){
    event.preventDefault();
    $('#top-fests-header').hide().html('Top 5 Upcoming Festivals - 4 Week Top Artists').fadeIn('slow');
    loadingBar();
    fetchFestivals('short_term');
  });
}

function fourWeekArtistsButton(){
  $('#4-week-button').on('click', function(event){
    event.preventDefault();
    $('#top-artists-header').hide().html('Top Spotify Artists - Last 4 Weeks').fadeIn('slow');
    fetchArtists('short_term');
  })
}

function sixMonthArtistsButton(){
  $('#6-mo-button').on('click', function(event){
    event.preventDefault();
    $('#top-artists-header').hide().html('Top Spotify Artists - Last 6 Months').fadeIn('slow');
    fetchArtists('medium_term');
  });
}

function allTimeArtistsButton(){
  $('#all-time-button').on('click', function(event){
    event.preventDefault();
    $('#top-artists-header').hide().html('Top Spotify Artists - All Time').fadeIn('slow');
    fetchArtists('long_term');
  });
}

function fetchArtists(range) {
  $.ajax({
    url: '/artists?range=' + range
  }).then(collectArtists)
  .then(renderArtists)
  .fail(handleError);
}

function fetchFestivals(range) {
  $.ajax({
    url: '/festivals?range=' + range
  })
  .then(collectFestivals)
  .then(renderFestivals)
  .fail(handleError);
}

function collectArtists(artistsData){
  return artistsData.map(createArtistHTML);
}

function createArtistHTML(artist){
  return $(
    "<div class='col-md-3 artist text-center'>"
    + artist.name
    + "</div>"
  );
}

function renderArtists(artistsData){
  $('#top-artists').html(artistsData);
}

function createFestHTML(fest, index){
  return(
    "<tr>"
    + "<td class='table-body-default'>" + (index + 1) + "</td>"
    + "<td class='table-fest-link'><a href='" + fest.url + "' title='View this festival on Songkick' target='_blank'>" + fest.name + "</a></td>"
    + "<td class='table-fest-location'>" + fest.location + "</td>"
    + "<td class= 'table-fest-dates'>" + fest.start_date + " - " + fest.end_date + "</td>"
    + "<td class='table-artists'>" + preRenderFestArtists(fest.top_artists) + "</td>"
    + "<td class='table-artists'>" + preRenderFestArtists(fest.rec_artists) + "</td>"
    + "<td class='table-other-artists'><a href='" + fest.url + "' title='View all artists for this festival on Songkick' target='_blank'>" + fest.other_artists_count + "+</a></td>"
    + "</tr>"
  )
}

function preRenderFestArtists(artists) {
  return artists.map(function(artist) {
    return artist.name + "<br>"
  }).join('')
}

function renderFestivals(festivalsData){
  $('#top-fests-data').html(festivalsData);
  loadingStatusCleanup();
  $('#top-festivals').show();
}

function loadingStatusCleanup(){
  $('.progress-bar').attr('aria-valuenow', 100).css('width', '100%');
  $('#progress-bar').fadeOut('fast');
  $('#loading-status').hide();
  clearTimeout(loadingStageOne);
  clearTimeout(loadingStageTwo);
  clearTimeout(loadingStageThree);
}

function collectFestivals(festivalsData){
  return festivalsData.map(createFestHTML);
}

function handleError(error){ console.log(error); }
