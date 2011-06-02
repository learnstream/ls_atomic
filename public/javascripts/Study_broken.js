$(document).ready(function() {
              

  $("#show-answer").bind('ajax:success', function(event, data, status, xhr){
      $("#answer").hide();
      $("#answer").html(data.text);
      $("#answer").fadeIn('slow');
      $("#rate-button-panel").show();
      $("#show-answer").hide();
      $("#study-item").text("What did you think?");
      $.get("/steps/" + data.id + "/help/", function(data) {

        var video_data = data.videos;
        var comp_data = data.components;

      
        if ((video_data.length > 0) || (comp_data.length > 0)) {
            $("#video-help-header").hide();
            $("#component-help-header").hide();
            $("#help").fadeIn('slow');
        }


        if (video_data.length > 0) {
          $("#video-help-header").show();
         // load_youtube_player(video_data[0].url,video_data[0].start_time,0,"video-embed-area");
 
          for (i = 0; i < video_data.length; i++) {
            video = video_data[i];
            var videoID = getYoutubeID(video.url, 'v');
            var old_html = $("#help-items-videos").html();
            $("#help-items-videos").html(old_html + '<li>' + video.name + ' | <a class="youtube" href="#" rel="' + videoID + '" title="' + video.name + '" id="' + i + '" data-start="5">Watch</a><br />' + video.description + '</li>');

          }
        }

        $("a.youtube").YouTubePopup({ 'youtubeID': $(this).attr('rel'), 'start': parse_start(video_data, $(this).attr('id')) }); 

        if (comp_data.length > 0){
          $("#component-help-header").show();
          for (i = 0; i < comp_data.length; i++) {
            comp = comp_data[i];
            var old_html = $("#help-items-components").html();
            $("#help-items-components").html(old_html + '<li><a href="' + comp.path + '">' + comp.name + '</a></li>');
          } 
        }
      });
    });
 });


function parse_start(video_data, index){
  alert(index);
  
  return video_data[parseInt(index)].start_time;

}
