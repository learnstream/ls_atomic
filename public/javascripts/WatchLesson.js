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

var displayDocument = function(new_event) {
  clearInterval(waitingForNext);
  $("#lesson-area").hide();
  $("#video-area").html($("<div>").attr("id", "player")); 
  ytplayer = null;
  $("#document-area").text(new_event.content);
  $("#document-area").markdown();
}

var restoreLesson = function(events) {
  $("#lesson-area").show();
  $("#document-area").html("");
  var last_index = $(".event").last().attr("data-index");
  var last_event = events[last_index];
  loadAndPlayVideo(getYoutubeID(last_event.video_url, "v"),
                   last_event.start_time,
                   last_event.end_time,
                   "player", 0);
}

var displayNote = function(new_event,newdiv) {
    newdiv.append($("<div />").addClass("content")
                              .text(new_event.content));

    newdiv.find(".content").markdown();
    
    var offset = -1*($("#content").outerHeight() - $("#content .event").last().outerHeight())/2;
    $("#content").scrollTo(newdiv, 500, { "offset" : offset });
}

var displayQuiz = function(new_event,newdiv) {
 $("<div />").text("Loading quiz...")
              .attr("id", "quiz_" + new_event.id)
              .appendTo(newdiv);

  var course_id = $("#course-id").text();

  $.get("/courses/" + course_id + "/study/" + new_event.id + ".js #study-area", function() {
      // scroll again because the size is larger... 
        var offset = -1*($("#content").outerHeight() - $("#content .event").last().outerHeight())/2;
        $("#content").scrollTo($("#content .event").last(), 500, { "offset" : offset });
        $("#content .event").last().markdownInner();

        $("#quiz_" + new_event.id).find("#response_answer").keyup(function() {
          answer = $(this).val();
          if (answer == "") {
            $("#quiz_" + new_event.id).find("#answer-morph").val("Don't know");
          } else {
            $("#quiz_" + new_event.id).find("#answer-morph").val("Check answer");
          }
        });

    });  
}

var prepareVideo = function(new_event, index, events, lesson_status_id, current_index) {

  // Create replay link
  var timelinkdiv = $("<div />").addClass("play-event");
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


  // play the video clip 
  console.log(ytplayer);
  
  if (ytplayer == null || index > 0 && getYoutubeID(ytplayer.getVideoUrl(), "v") != getYoutubeID(new_event.video_url, "v")) {
    $("#video-area").html($("<div>").attr("id", "player")); 
    ytplayer = null;
  }

  loadAndPlayVideo(getYoutubeID(new_event.video_url, "v"),
                   new_event.start_time,
                   new_event.end_time,
                   "player", 1);


  // get ready to load next clip
  if (new_event.type == "Note") {
    waitingForNext = setInterval(function() {
        if (getYoutubeID(ytplayer.getVideoUrl(), "v") == getYoutubeID(new_event.video_url, "v") && ytplayer.getCurrentTime() > new_event.end_time) {
          loadEvent(index + 1, events, lesson_status_id, current_index);
        }
      }, 200);
  }

  return timelinkdiv;
}

var createNavLinks = function(index, events,lesson_status_id, current_index) {
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
}

var loadEvent = function(index, events, lesson_status_id, current_index) {

  var new_event = events[index];
  console.log(new_event);

  var newdiv = $("<div />").addClass(new_event.type.toLowerCase())
                           .addClass("event")
                           .attr("data-index", index)
                           .appendTo($("#content"));
  
  // ignore old transition events
  if (typeof(waitingForNext) != "undefined")
    clearInterval(waitingForNext);

  // hide resume if we've already reached there
  if (current_index == index) $("#resume").hide();
  
  if (new_event.type == "Document") {
    newdiv.append($("<p>").text(new_event.content.substring(0, 100) + "...")); 
    newdiv.append($("<div>").addClass("play-event").append(
        $("<a>")
        .attr("href","#")
        .click(function() {
          clearInterval(waitingForNext);
          displayDocument(new_event);
          var returnlink = 
            $("<a>").attr("href","#")
                    .addClass("video-nav-link")
                    .text("Return to lesson")
                    .click(function() { restoreLesson(events); });

          returnlink.wrap("<div></div>");
          $("#document-area").append($("<div>").addClass("nav-link-area").append(returnlink));
          return false; 
          })
        .text("View document")));
    displayDocument(new_event);
  } else {
    $("#document-area").html("");
    $("#lesson-area").show();

    if (new_event.type == "Note") {
      displayNote(new_event, newdiv);
    } else if (new_event.type == "Quiz") {
      displayQuiz(new_event, newdiv);
    }

    timelink = prepareVideo(new_event, index, events,lesson_status_id, current_index);
    newdiv.append(timelink);
  }
 

  createNavLinks(index,events,lesson_status_id,current_index);

  if (new_event.type == "Document") {
    $("<div>").addClass("nav-link-area")
              .append($("#nextlink").clone(true)
                                    .addClass("video-nav-link"))
              .appendTo("#document-area");
  }

  if (new_event.type == "Note") {
    // scroll to the new div 
    
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

