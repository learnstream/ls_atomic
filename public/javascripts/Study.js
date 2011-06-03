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
          
          for (i = 0; i < video_data.length; i++) {
            var old_html = $('#help-items-videos').html();
            var watch_link = constructColorBoxLink(video_data[i], i);
            $('#help-items-videos').html(old_html + watch_link);
            var video = video_data[i];
        
          }

          $(".color-box-link").each( function(){ 
              $(this).colorbox({
                innerHeight:300, innerWidth:485, inline:true,
                href: "#color-box-container", 
                onOpen:  function() {
                  loadAndPlayVideo($(this).attr('data-url'),
                                   $(this).attr('data-start-time'),
                                   $(this).attr('data-end-time'), 
                                   'embed-video-area');
                  return false;
                },
                onCleanup: function() {
                  $("#color-box-container").html('<div id="embed-video-area"></div>');
                  ytplayer = null;
                  clearInterval(ytTimer);
                }
              });
          }); 
        }
        /*
        if (comp_data.length > 0){
          $("#component-help-header").show();
          for (i = 0; i < comp_data.length; i++) {
            comp = comp_data[i];
            var old_html = $("#help-items-components").html();
            $("#help-items-components").html(old_html + '<li><a href="' + comp.path + '">' + comp.name + '</a></li>');
          } 
        }*/
      });
    });
 });


