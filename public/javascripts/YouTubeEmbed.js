var current_end_time;
var ytplayer;
var ytTimer;


// Gets the Youtube ID from a URL; name => 'v' for youtube URL format
function getYoutubeID(url, name) {
    var urlparts = url.split('?');
    if (urlparts.length > 1) {
        var parameters = urlparts[1].split('&');
        for (var i = 0; i < parameters.length; i++) {
            var paramparts = parameters[i].split('=');
            if (paramparts.length > 1 && unescape(paramparts[0]) == name) {
                return unescape(paramparts[1]);
            }
        }
    }
    return null;
}


// Loads the youtube player into the div with name 'embed_area'
function load_youtube_player(video_url, start_time, end_time, embed_area) {
  var videoID = getYoutubeID(video_url, 'v');
  alert(start_time + 3);
  var params = { allowScriptAccess: "always" };
  var atts = { id: "ytPlayer" };
  swfobject.embedSWF("http://www.youtube.com/v/" + videoID + "&enablejsapi=1&playerapiid=player1&start=" + start_time, embed_area, "480", "295", "8", null, null, params, atts); 
  if (! end_time == 0){
  current_end_time = end_time;
  ytTimer = window.setInterval(check_end_time, 1000);
  }
}


//Called after successful youtube player load
function onYouTubePlayerReady(playerId) {
    alert('ytready');
      ytplayer = document.getElementById("ytPlayer");
    }



// plays the video in the video player ytplayer
function play_video(video_url, start_time, end_time) {
  var videoID = getYoutubeID(video_url, 'v');
  ytplayer.loadVideoById(videoID, start_time)

  if (! end_time == 0){
    current_end_time = end_time;
    clearInterval(ytTimer);
    ytTimer = window.setInterval(check_end_time, 1000);
  }
}


// Checks to see if current video is past the designated 'end time'
// This function should be called every second by ytTimer, after playing a video
function check_end_time() {
  var time = ytplayer.getCurrentTime();
  if (time > current_end_time){
    ytplayer.pauseVideo();
    clearInterval(ytTimer);
  }
}


