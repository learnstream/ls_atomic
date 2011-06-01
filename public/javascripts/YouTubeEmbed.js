var current_end_time;
var ytplayer;

// name is 'v' for youtube videos... pulls out parameter.
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

function check_end_time() {
  var time = ytplayer.getCurrentTime();
  // var end_time = parseInt($("#video-end-time").text());
  if (time > current_end_time){
    ytplayer.pauseVideo();
  }
}

function onYouTubePlayerReady(playerId) {
      ytplayer = document.getElementById("ytPlayer");
    }

// plays the video in the video player ytplayer
function play_video(video_url, start_time, end_time) {
  var videoID = getYoutubeID(video_url, 'v');
  ytplayer.loadVideoById(videoID, start_time)
  current_end_time = end_time;
}

// cue_videos()
// Looks for all video-area IDs and binds the title of the video
// to a play_video function
function cue_videos() {
  $("div#related-videos > div#video-area").each(function(index){
      var video_url = $("#video-embed-url", this).text();
      var start_time = parseInt($("#video-start-time", this).text());
      var end_time = parseInt($("#video-end-time", this).text());
      $("a", this).click(function(){
            play_video(video_url, start_time, end_time);
            return false;
      }); 
    });

}


$(document).ready(function(){

  cue_videos();


  var videoURL = $("#video-embed-url").text();
  var videoID = getYoutubeID(videoURL, 'v'); 
  var videoStart = $("#video-start-time").text();
  var params = { allowScriptAccess: "always" };
  var atts = { id: "ytPlayer" };
  swfobject.embedSWF("http://www.youtube.com/v/" + videoID + "&enablejsapi=1&playerapiid=player1&start=" + videoStart, 
                     "video-embed-area", "480", "295", "8", null, null, params, atts); 

  var timer = window.setInterval(check_end_time, 1000);

  

});

