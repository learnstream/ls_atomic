$(document).ready(function() { 
    var lessonId = $("#lesson-id").text();

    $.get('/lessons/' + lessonId + '/events.json', function(data) {
      var first = data[0];

      waitingForTimeToSwitch = Number.MAX_VALUE;
      waitingForTimeToEnd = Number.MAX_VALUE;
      loadAndPlayVideo( getYoutubeID(first.video_url, "v"), first.start_time, 0, "player");
      loadEvent(first);

      last_event = 0;
      afterQuizBuffer = false;
      setInterval(function() { loadEvents(data) }, 1000);
    });
});

var prepareQuiz = function() {
  $("#response_submit").click(function() {
    var user_id = $("#response_user_id").val();
    var quiz_id = $("#response_quiz_id").val();
    var answer = $("#response_answer").val();

    $.post('/responses/', { response :  { quiz_id: quiz_id, answer: answer, user_id: user_id }}, prepareResponse);
    return false;
  });
};

var prepareResponse = function(data) {
  var response_html = $(data).find("#study-area").html();
  $("#quiz_area").html(response_html);
  $("#help").hide();
  $(".quizbutton").click(function() {
    var href = $(this).attr('href');
    $.get(href, function() { $("#quiz_area").html(""); });

    afterQuizBuffer = true;
    ytplayer.playVideo();
    setTimeout(function() { afterQuizBuffer = false; }, 3000);

    // update the appropriate .Quiz with response info
    var rgx_id = /quizzes\/(\d+)/;
    var quiz_id = href.match(rgx_id)[1];
    $("#quiz" + quiz_id).removeClass("Quiz").addClass("Note").text("done");
    return false;
  });
};

var loadEvents = function(events) {
  var time = ytplayer.getCurrentTime();
  var currentId = getYoutubeID(ytplayer.getVideoUrl(), "v"); 

  var i = last_event + 1;
  //console.log(waitingForTimeToEnd);
  //console.log(waitingForTimeToSwitch);

  if (time > waitingForTimeToEnd) {
    ytplayer.pauseVideo();
    return;
  }

  if (time > waitingForTimeToSwitch) { 
    next_event = events[last_event+1];
    loadEvent(next_event);
    loadAndPlayVideo( getYoutubeID(next_event.video_url, "v"), next_event.start_time, 0, "player" );
    last_event++;
    currentUrl = next_event.video_url;
  }

  while(i < events.length && 
        getYoutubeID(events[i].video_url, "v") == currentId && 
        events[i].start_time < time) {
    loadEvent(events[i]);
    last_event = i;
    i++;
  }

  if (i == events.length) {
    // if we know this is the last event, get ready to end the video
    waitingForTimeToEnd = events[last_event].endTime;
    waitingForTimeToSwitch = Number.MAX_VALUE;
  } else if (events[last_event+1].video_url != currentId) {
    // if we know the next event is a switch, we'll get ready for it
    waitingForTimeToSwitch = events[last_event].endTime;
    waitingForTimeToEnd = Number.MAX_VALUE;
  } else {
    waitingForTimeToSwitch = Number.MAX_VALUE;
    waitingForTimeToEnd = Number.MAX_VALUE;
  }

  if (ytplayer.getPlayerState() == 2) return;
  if (afterQuizBuffer) return;

  for (i = 0; i < events.length; i++) { 
    if (events[i].type == "Quiz" && getYoutubeID(events[i].video_url, "v") == currentId && Math.abs(events[i].start_time - time) <= 1) {
      ytplayer.pauseVideo();
      $("#quiz_area").load("/quizzes/" + events[i].id + "/ #study-area", prepareQuiz);
    }
  }


  //for (var top=0; events[top].start_time < time; top++) { }
}

var loadEvent = function(next_event) {
  var newdiv = $("<div />").addClass(next_event.type);
  if (next_event.type == "Note") {
    newdiv.text(next_event.content)
  } else if (next_event.type == "Quiz") {
    newdiv.text("You have an unanswered quiz!")
          .attr("id", "quiz" + next_event.id)
          .click(function() { 
              afterQuizBuffer = false; 
              ytplayer.pauseVideo();
              ytplayer.seekTo(next_event.start_time, true); });
  }
  $("#content").append(newdiv);
}



