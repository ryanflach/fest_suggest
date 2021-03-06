$(document).ready(function(){
  allTimeArtistsButton();
  sixMonthArtistsButton();
  fourWeekArtistsButton();
  allTimeFestButton();
  sixMonthFestButton();
  fourWeekFestButton();
  hideInitialElements();
  $('#all-time-fest-button').click();
});

function hideInitialElements(){
  $('#top-festivals').hide();
  $('#progress-bar').hide();
  $('#loading-status').hide();
  $('#songkick').hide();
  $('.progress-bar').attr('aria-valuenow', 0).css('width', '0%');
  clearActiveTimeouts();
}

function loadingBar(){
  hideInitialElements();
  $('#progress-bar').fadeIn('fast');
  $('.progress-bar').attr('aria-valuenow', 5).css('width', '5%');
  $('#loading-status').hide().html('Gathering recommended artists from Spotify based on your selected top artists...').fadeIn('slow');
  loadingStageOne = setTimeout(theWheelsAreInMotion, 1000);
}

function theWheelsAreInMotion(){
  $('.progress-bar').attr('aria-valuenow', 30).css('width', '30%');
  $('#loading-status').hide().html('Gathering Songkick data for each of your top artists...').fadeIn('slow');
  loadingStageTwo = setTimeout(sweetProgress, 1250);
}

function sweetProgress(){
  $('.progress-bar').attr('aria-valuenow', 55).css('width', '55%');
  $('#loading-status').hide().html('Determining which top artists have upcoming festivals...').fadeIn('slow');
  loadingStageThree = setTimeout(finalCountdown, 1250);
}

function finalCountdown(){
  $('.progress-bar').attr('aria-valuenow', 80).css('width', '80%');
  $('#loading-status').hide().html('Analyzing results...').fadeIn('slow');
}

function allTimeFestButton(){
  $('#all-time-fest-button').on('click', function(event){
    event.preventDefault();
    $('#all-time-button').click();
    $('#top-fests-header').hide().html('Top 5 Upcoming Festivals - All Time Top Artists').fadeIn('slow');
    loadingBar();
    fetchFestivals('long_term');
  });
}

function sixMonthFestButton(){
  $('#6-mo-fest-button').on('click', function(event){
    event.preventDefault();
    $('#6-mo-button').click();
    $('#top-fests-header').hide().html('Top 5 Upcoming Festivals - 6 Month Top Artists').fadeIn('slow');
    loadingBar();
    fetchFestivals('medium_term');
  });
}

function fourWeekFestButton(){
  $('#4-week-fest-button').on('click', function(event){
    event.preventDefault();
    $('#4-week-button').click();
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
  });
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
    "<div class='col-md-3 artist text-center'>" +
    artist.name +
    "</div>"
  );
}

function renderArtists(artistsData){
  $('#top-artists').html(artistsData);
}

function createFestHTML(fest, index){
  return(
    "<tr id='fest-0" +
    (index + 1) +
    "'>" +
    "<td class='table-body-default'>" + (index + 1) + "</td>" +
    "<td class='table-fest-link'><a href='" + fest.url + "' title='View this festival on Songkick' target='_blank'>" + fest.name + "</a></td>" +
    "<td class='table-fest-location'>" + fest.location + "</td>" +
    "<td class= 'table-fest-dates'>" + fest.start_date + " - " + fest.end_date + "</td>" +
    "<td class='table-artists'>" + preRenderFestArtists(fest.top_artists) + "</td>" +
    "<td class='table-artists'>" + preRenderFestArtists(fest.rec_artists) + "</td>" +
    "<td class='table-other-artists'><a href='" + fest.url + "' title='View all artists for this festival on Songkick' target='_blank'>" + fest.other_artists_count + "+</a></td>" +
    "<td class='table-playlist'><button class='playlist' disabled='true'>Loading...</button></td>" +
    "</tr>"
  );
}

function setButtonText(fests) {
  $('.playlist').each(function(_index, button){
    var $button = $(button);
    var fest = $button.closest('tr').find('.table-fest-link').text();
    $.ajax({
      url: '/playlists/' + fest
    })
    .then(setFollowText.bind(this, $button))
    .fail(handleError);
  });
}

function setFollowText(button, response) {
  var text = response.playlist.followed ? 'Unfollow' : 'Follow';
  button.text(text);
  button.attr('class', 'playlist ' + text.toLowerCase());
  button.prop('disabled', false);
}

function preRenderFestArtists(artists) {
  return artists.map(function(artist) {
    return artist.name + "<br>";
  }).join('');
}

function renderFestivals(festivalsData){
  $('#top-fests-data').html(festivalsData);
  loadingStatusCleanup();
  $('#top-festivals').show();
  $('#songkick').fadeIn('fast');
  setButtonText(festivalsData);
  followButtons();
}

function followButtons() {
  $('.playlist').on('click', function(e){
    e.preventDefault();
    var $button = $(e.target);
    var fest = $button.closest('tr').find('.table-fest-link').text();
    $button.prop('disabled', true);
    $.ajax({
      type: 'PUT',
      url: '/playlists/' + fest,
      data: { playlist: { text: $button.text() } }
    })
    .then(updateButton.bind(this, $button))
    .fail(handleError);
  });
}

function updateButton(button, _response) {
  var existingText = button.text();
  var newText = existingText === 'Follow' ? 'Unfollow' : 'Follow';
  button.text(newText);
  button.attr('class', 'playlist ' + newText.toLowerCase());
  button.prop('disabled', false);
}

function loadingStatusCleanup(){
  $('.progress-bar').attr('aria-valuenow', 100).css('width', '100%');
  $('#progress-bar').fadeOut('fast');
  $('#loading-status').hide();
  clearActiveTimeouts();
}

function clearActiveTimeouts(){
  if ('loadingStageOne' in window) clearTimeout(loadingStageOne);
  if ('loadingStageTwo' in window) clearTimeout(loadingStageTwo);
  if ('loadingStageThree' in window) clearTimeout(loadingStageThree);
}

function collectFestivals(festivalsData){
  return festivalsData.map(createFestHTML);
}

function handleError(error){ console.log(error); }
