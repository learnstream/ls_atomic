$(document).ready(function() {
  $("#rate-button-panel").hide();
  $("#help").hide();
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
          $("#help").show();
        }

        for (i = 0; i < video_data.length; i++) {
          video = video_data[i];
          var old_html = $("#help-items-videos").html();
          $("#help-items-videos").html(old_html + '<li>' + video.name + ' | <a href = "' + video.url + '">Watch</a><br />' + video.description + '</li>');
        }

        for (i = 0; i < comp_data.length; i++) {
          comp = comp_data[i];
          var old_html = $("#help-items-components").html();
          $("#help-items-components").html(old_html + '<li><a href="' + comp.path + '">' + comp.name + '</a></li>');
        } 
        });
    });
 });
