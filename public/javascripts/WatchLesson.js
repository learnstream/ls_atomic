$(document).ready(function() { 
    var lessonId = $("#lesson-id").text();
    var lesson_status_id = $("#lesson-status-id").text();

    $.get('/lessons/' + lessonId + '/events.json', function(data) {
      loadEvent(0, data, lesson_status_id);
    });
});

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

var loadEvent = function(index, events, lesson_status_id) {
  var new_event = events[index];
  var newdiv = $("<div />").addClass(new_event.type.toLowerCase())
                           .addClass("event");

  var timelinkdiv = $("<div />").addClass("timelink");
  $("<a />").addClass("timelink")
            .text("Replay")
            .attr("href", "#")
            .click(function() {
                loadAndPlayVideo(getYoutubeID(new_event.video_url, "v"),
                                 new_event.start_time,
                                 new_event.end_time,
                                 "player", 1);
                return false;  })
            .appendTo(timelinkdiv);


  $("#nextlink").unbind('click');
  $("#showall").unbind('click');

  if (index == events.length - 1) {
    $("#nextlink").hide();
    $("#showall").hide();
  } else {

    $("#nextlink").click(function() {
                        loadEvent(index + 1, events);
                        $("#content").scrollTo($("#content .event").last(), 500);
                        return false;
                      });

    $("#showall").click(function() {
      for (var i=index + 1; i < events.length; i++) {
        loadEvent(i, events);
      }
      $("#nextlink").hide();
      $("#showall").hide();
      return false;
    });
  }
  
  if (new_event.type == "Note") {
    newdiv.text(new_event.content);
    $.post("/lesson_statuses/" + lesson_status_id, function() {});

  } else if (new_event.type == "Quiz") {
    $("<div />").text("Loading quiz...")
                .attr("id", "quiz_" + new_event.id)
                .appendTo(newdiv);
    $.get("/quizzes/" + new_event.id + ".js #study-area");
  }

  newdiv.append(timelinkdiv);

  $("#content").append(newdiv);


  loadAndPlayVideo(getYoutubeID(new_event.video_url, "v"),
                   new_event.start_time,
                   new_event.end_time,
                   "player", 1);

  
  if (typeof(waitingForNext) != "undefined")
    clearInterval(waitingForNext);

  if (new_event.type == "Note") {
    console.log("Should be setting interval");
    waitingForNext = setInterval(function() {
        if (ytplayer.getCurrentTime() > new_event.end_time) {
          loadEvent(index + 1, events);
          $("#content").scrollTo($("#content .event").last(), 500);
        }
      }, 200);
  }
}

