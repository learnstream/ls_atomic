$(document).ready(function() {
    $("#load-video").click(function() {
      var video_url = $("#video_url").val();
      var video_id = getYoutubeID(video_url, 'v');
      console.log(video_id);
      loadAndPlayVideo(video_id, 0, 0, "video-player", 0);
    });
});
