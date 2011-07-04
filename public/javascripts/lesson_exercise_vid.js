$(document).ready(function() {
    if($("#player").attr('data-url') != "") 
      loadAndPlayVideo(getYoutubeID($("#player").attr("data-url"), "v"), $("#player").attr("data-starttime"), $("#player").attr("data-endtime"), "player", 0);
});
