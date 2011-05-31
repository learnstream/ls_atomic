$(document).ready(function() {
  $("#rate-button-panel").hide();
  $("#show-answer").bind('ajax:success', function(event, data, status, xhr){
      $("#answer").html(data.text);
      $("#rate-button-panel").show();
      $("#show-answer").hide();
      $("#study-item").text("What did you think?");

    });
 });
