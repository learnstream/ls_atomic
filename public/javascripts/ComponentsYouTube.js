// Javascript for component show page.
// Also requires the (global) YouTubeEmbed.js

// Looks for all video-area IDs and binds the title of the video to a play function
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
  var start_time = parseInt($("#video-start-time").text());
  var end_time = parseInt($("#video-end-time").text());
  load_youtube_player(videoURL, start_time, end_time,  "video-embed-area");

  

});

