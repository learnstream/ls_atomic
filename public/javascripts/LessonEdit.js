$(document).ready(function() {
    $("#load-video").click(function() {
      var video_url = $("#load_video_url").val();
      var video_id = getYoutubeID(video_url, 'v');
      console.log(video_id);
      loadAndPlayVideo(video_id, 0, 0, "video-player", 0);
    });



    $("#start-sync").click(function(){
        var time = parseInt(ytplayer.getCurrentTime());
        console.log(time);
        $("#start_time").val(time);
        return false;
      });

    $("#end-sync").click(function(){
        var time = parseInt(ytplayer.getCurrentTime());
        console.log(time);
        $("#end_time").val(time);
        return false;
      });

    $("#new_note").submit(function(){
        var video_url = ytplayer.getVideoUrl();
        $("#video_url").val(video_url);
        var data = $("#new_note").serialize();
        $.post('/notes/', data, function(data){ 
          $(':input','#new_note')
           .not(':button, :submit, :reset, :hidden')
            .val('')
          console.log(data); });

        return false;
    });
});
