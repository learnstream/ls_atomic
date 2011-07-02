var current_end_time = 0; 
var ytplayer = null; 
var ytTimer = null;

// Gets the Youtube ID from a URL; name => 'v' for youtube URL format
getYoutubeID = function(url, name) {
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
};



createYoutubeURL = function(videoID, start_time) {
  return 'http://www.youtube.com/v/' + videoID + 
    '&enablejsapi=1&playerapiid=player1&autoplay=1&start=' + start_time;
}


constructColorBoxLink = function(video, index) {
  var videoID = getYoutubeID(video.url, 'v');
  var old_html = $("#help-items-videos").html();
  return '<li>' + video.name + ' | ' +
    '<a id="video-watch-link-' + index +'" ' + 
    'class="color-box-link" ' +
    'href="#"' +
    'data-url="' + videoID + '" ' +
    'data-start-time="' + video.start_time + '" ' +
    'data-end-time="' + video.end_time + '" ' +
    '>' + 'Watch' + '</a></li>';
};


constructVideoWatchLink = function(video, index) {
  var videoID = getYoutubeID(video.url, 'v');
  var old_html = $("#help-items-videos").html();

  return '<li>' + video.name + ' | ' + 
    '<a class="youtube" href="#" ' + 
    'data-url="' + videoID + '" ' +
    'data-start-time="' + video.start_time + '" ' +
    'data-end-time="' + video.end_time + '" ' +
    'id="video-watch-link-' + index + '">Watch</a><br />'
    + video.description + '</li>';
};


// Loads the youtube player into the div with name 'embed_area'
loadYouTubePlayer = function(video_id, start_time, end_time, embed_area, autoplay) {
  if (typeof autoplay == 'undefined') autoplay = 1;
  
  var params = { allowScriptAccess: "always" };
  var atts = { id: "ytPlayer" };
  swfobject.embedSWF("http://www.youtube.com/v/" + video_id + "&enablejsapi=1&playerapiid=player1&autoplay=" + autoplay+"&start=" + start_time, embed_area, "480", "295", "8", null, null, params, atts); 
};

function loadAndPlayVideo(video_id, start_time, end_time, embed_area, autoplay) {
  if (typeof autoplay == 'undefined') autoplay = 1;
  if (ytplayer == null) 
   loadYouTubePlayer(video_id, start_time, end_time, embed_area, autoplay);
  else  {
    if (video_id == getYoutubeID(ytplayer.getVideoUrl(), "v")) {
      ytplayer.seekTo(start_time, "true");
      if (autoplay == 1) ytplayer.playVideo();
    } else {
      if (autoplay == 1) {
        ytplayer.loadVideoById(video_id, start_time);
      } else {
        ytplayer.cueVideoById(video_id, start_time);
      }
    }
  }
  
  if (end_time != 0) {
    current_end_time = end_time;
    clearInterval(ytTimer);
    ytTimer = window.setInterval(check_end_time, 1000);
  }
}              

//Called after successful youtube player load
function onYouTubePlayerReady() {
  ytplayer = document.getElementById("ytPlayer");
}

// Checks to see if current video is past the designated 'end time'
// This function should be called every second by ytTimer, after playing a video
function check_end_time() {
  var time = ytplayer.getCurrentTime();
  if (current_end_time != 0 && time > current_end_time){
    ytplayer.pauseVideo();
    clearInterval(ytTimer);
  }
}
