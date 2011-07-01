$(document).ready(function() { 
    var lessonId = $("#lesson-id").text();
    var lesson_status_id = $("#lesson-status-id").text();

    $.get('/lessons/' + lessonId + '/events.json', function(data) {

      var current_index = -1;

      if(data.current_event != -1) {
        for (var i = 0; i < data.events.length; i++) {
          if (data.events[i].event_id == data.current_event) {
            current_index = i;
            break;
          }
        }


        var events_loaded = $("#content .event").length;
        if (current_index != -1 && current_index >= events_loaded) { 

          $("#resume").show();
          $("#resume").click(function() {
            var events_loaded = $("#content .event").length;
            for ( i = events_loaded; i <= current_index; i++)  {
              loadEvent(i, data.events, lesson_status_id, current_index);
            }

            $(this).hide();
            return false;
          });

          $("#resume").text("Resume at " + formatTime(data.events[current_index].start_time)); 
        }
      }

      loadEvent(0, data.events, lesson_status_id, current_index);
    });
});

var formatTime = function(time) {
  var str = "";
  str += Math.floor(time/60);
  str += ":";
  if (time % 60 < 10)
    str += "0";

  str += time % 60;
  return str;
};

var loadEvent = function(index, events, lesson_status_id, current_index) {
  var new_event = events[index];
  
  // hide resume if we've already reached there
  
  if (current_index == index) $("#resume").hide();

  // add the div on the page

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
                        loadEvent(index + 1, events, lesson_status_id, current_index);
                        return false;
                      });

    $("#showall").click(function() {
      for (var i=index + 1; i < events.length; i++) {
        loadEvent(i, events, lesson_status_id, current_index);
      }
      $("#nextlink").hide();
      $("#showall").hide();
      return false;
    });
  }
  
  if (new_event.type == "Note") {
    newdiv.text(new_event.content);


  } else if (new_event.type == "Quiz") {
    $("<div />").text("Loading quiz...")
                .attr("id", "quiz_" + new_event.id)
                .appendTo(newdiv);

    var course_id = $("#course-id").text();

    $.get("/courses/" + course_id + "/study/" + new_event.id + ".js #study-area", function() {
        // scroll again because the size is larger... 
          var offset = -1*($("#content").outerHeight() - $("#content .event").last().outerHeight())/2;
          $("#content").scrollTo($("#content .event").last(), 500, { "offset" : offset });
          MathJax.Hub.Typeset();

          $(newdiv > "#response_answer").keyup(function() {
            answer = $("#response_answer").val();
            if (answer == "") {
            $("#answer-morph").val("Don't know");
            } else {
            $("#answer-morph").val("Check answer");
            }
    });


          });
  }

  newdiv.append(timelinkdiv);

  $("#content").append(newdiv);

  if (new_event.type == "Note") {
    // scroll to the new div 
    
    var offset = -1*($("#content").outerHeight() - $("#content .event").last().outerHeight())/2;
    $("#content").scrollTo($("#content .event").last(), 500, { "offset" : offset });

    // render latex
    MathJax.Hub.Typeset();
  }


  // play the video clip 

  loadAndPlayVideo(getYoutubeID(new_event.video_url, "v"),
                   new_event.start_time,
                   new_event.end_time,
                   "player", 1);


  // get ready to load next clip
  
  if (typeof(waitingForNext) != "undefined")
    clearInterval(waitingForNext);

  if (new_event.type == "Note") {
    waitingForNext = setInterval(function() {
        if (ytplayer.getCurrentTime() > new_event.end_time) {
          loadEvent(index + 1, events, lesson_status_id, current_index);
        }
      }, 200);
  }

  // update lesson status
  
  var data = { "lesson_status" : { "event_id" : new_event.event_id }};

  if (index == events.length - 1)  {
    var completed = "true";
    data["lesson_status"]["completed"] = completed;
  }


  $.ajax({
    url: "/lesson_statuses/" + lesson_status_id, 
    data: data,
    type: "PUT" } );
}

