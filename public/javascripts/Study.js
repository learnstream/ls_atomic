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
      $.get("/steps/" + data.id + "/help/", function(comp_data) {
        if (comp_data.length > 0) {
          $("#help").show();
        }

        for (i = 0; i < comp_data.length; i++) {
          comp = comp_data[i];
          var old_html = $("#help-items").html();
          $("#help-items").html(old_html + '<li><a href="' + comp.path + '">' + comp.name + '</a></li>');
        } 
        });
    });
 });
