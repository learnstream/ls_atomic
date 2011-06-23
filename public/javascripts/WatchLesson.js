$(document).ready(function() { 
    var lessonId = $("#lesson-id").text();

    $.get('/lessons/' + lessonId + '/events.json', function(data) {
      loadEvent(0, data);
    });
});

var prepareQuiz = function(data, status, xhr) {

  $("#study-area").replaceWith($("#study-area").html());

  $("#response_submit").click(function() {
    var user_id = $("#response_user_id").val();
    var quiz_id = $("#response_quiz_id").val();
    var answer = $("#response_answer").val();

    $.post('/responses/', { response :  { quiz_id: quiz_id, answer: answer, user_id: user_id }}, prepareResponse);
    return false;
  });
};

var prepareResponse = function(data, status, xhr) {

  var response_html = $(data).find("#study-area").html();
  $("#quiz_area").html(response_html);
  $("#help").hide();
  $(".quizbutton").each(function() {
      $(this).data("url", $(this).attr('href'));
      $(this).attr('href', '#');
    });

  $(".quizbutton").click(function(e) {
    var href = $(this).data('url');

    if (href.indexOf("study") == -1) {
      $.ajax({
        type: "PUT", 
        url: href, 
        data: {},
        success: function(data) { $("#quiz_area").html(""); }
      });
    }
   
    return false;
  });
};

var formatTime = function(time) {
  var str = "";
  str += Math.floor(time/60);
  str += ":";
  if (time % 60 < 10)
    str += "0";

  str += time % 60;
  console.log(str);
  return str;
};

var loadEvent = function(index, events) {
  var new_event = events[index];
  var newdiv = $("<div />").addClass(new_event.type.toLowerCase())
                           .addClass("event");

  var timelinkdiv = $("<div />").addClass("timelink");
  $("<a />").addClass("timelink")
            .text("Play video")
            .attr("href", "#")
            .click(function() {
                loadAndPlayVideo(getYoutubeID(new_event.video_url, "v"),
                                 new_event.start_time,
                                 new_event.end_time,
                                 "player", 1);
                return false;  })
            .appendTo(timelinkdiv);

  var nextlinkdiv = $("<div />").addClass("nextlink");
  $("<a />").text("Continue...")
            .attr("href", "#")
            .click(function() {
                loadEvent(index + 1, events);
                $(this).parent().remove();
                $("#content").scrollTo($("#content .event").last(), 500);
                return false;
                })
            .appendTo(nextlinkdiv);
  
  if (new_event.type == "Note") {
    newdiv.text(new_event.content)
  } else if (new_event.type == "Quiz") {
    $("<div />").text("Loading quiz...")
                .load("/quizzes/" + new_event.id + "/ #study-area", prepareQuiz)
                .appendTo(newdiv);
  }

  newdiv.prepend(timelinkdiv);

  $("#content").append(newdiv);

  if (index + 1 < events.length)
    $("#content").append(nextlinkdiv);

  loadAndPlayVideo(getYoutubeID(new_event.video_url, "v"),
                   new_event.start_time,
                   new_event.end_time,
                   "player", 1);

}
