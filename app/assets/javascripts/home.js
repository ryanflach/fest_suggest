$(document).ready(function(){
  allTimeArtistsButton();
  sixMonthArtistsButton();
  fourWeekArtistsButton();
  // allTimeFestButton();
  // sixMonthFestButton();
  // fourWeekFestButton();
  $('#top-festivals').hide();
});

function allTimeFestButton(){
  $('#all-time-fest-button').on('click', function(event){
    event.preventDefault();
    fetchFestivals('long_term');
  });
}

function sixMonthFestButton(){
  $('#all-time-fest-button').on('click', function(event){
    event.preventDefault();
    fetchFestivals('medium_term');
  });
}

function fourWeekFestButton(){
  $('#all-time-fest-button').on('click', function(event){
    event.preventDefault();
    fetchFestivals('short_term');
  });
}

function fourWeekArtistsButton(){
  $('#4-week-button').on('click', function(event){
    event.preventDefault();
    fetchArtists('short_term');
  })
}

function sixMonthArtistsButton(){
  $('#6-mo-button').on('click', function(event){
    event.preventDefault();
    fetchArtists('medium_term');
  });
}

function allTimeArtistsButton(){
  $('#all-time-button').on('click', function(event){
    event.preventDefault();
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
  }).then(collectFestivals)
  .then(renderFestivals)
  .fail(handleError);
}

function collectArtists(artistsData){
  return artistsData.map(createArtistHTML);
}

function createArtistHTML(artist){
  return $(
    "<p class='artist'>"
    + artist.artist.name
    + "</p>"
  );
}

function renderArtists(artistsData){
  $('#top-artists').html(artistsData);
}

function createFestHTML(fest){
  return $(
    "<tr>"
    + "<td>" + '*' + "</td>"
    + "<td><a href='" + fest.festival.uri + "' target='_blank'>" + fest.festival.displayName + "</a></td>"
    + "<td>" + fest.festival.location.city + "</td>"
    + "<td>holding</td>"
    + "<td>holding</td>"
    + "<td>holding</td>"
    + "</tr>"
  );
}

function renderFestivals(festivalsData){
  $('#top-fests-data').html(festivalsData);
  $('#top-festivals').show();
}

function collectFestivals(festivalsData){
  return festivalsData.map(createFestHTML);
}

function handleError(error){ console.log(error); }
