$(document).ready(function() {
              
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
});
