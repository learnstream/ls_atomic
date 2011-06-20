$(document).ready(function() { 
    var lessonId = $("#lesson-id").text();

    $.get('/lessons/' + lessonId + '/events.json', function(data) {
      var first = data[0];

      waitingForTimeToSwitch = Number.MAX_VALUE;
      waitingForTimeToEnd = Number.MAX_VALUE;
      loadAndPlayVideo( getYoutubeID(first.video_url, "v"), first.start_time, 0, "player");
      loadEvent(first);

      last_event = 0;
      //afterQuizBuffer = false;
      setInterval(function() { loadEvents(data); scrollToEvent(data); }, 1000);
    });

    userScrolling = false;
    $("#events-area-student").scroll(function() {
      userScrolling = true;
      setTimeout(function() { userScrolling = false; }, 5000);
    });
});

var prepareQuiz = function(data, status, xhr) {

  $("#study-area").replaceWith($("#study-area").html());

  if ($(".quizbutton").first().text() != "Next")
  { 
    //ytplayer.pauseVideo();
  }
  else 
  {
    $(".quizbutton").hide();
    ytplayer.playVideo();
    changeQuizState();
  }

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
   
    //afterQuizBuffer = true;
    ytplayer.playVideo();
    //setTimeout(function() { afterQuizBuffer = false; }, 3000);

    changeQuizState();

    return false;
  });
};

var changeQuizState = function() {

  var quiz_text = $("#question").text();
  quiz_text += " " + $("#correct_answer").text();
  
  var quiz_id = $("#quiz-id").text();

  var timelink = $("#quiz" + quiz_id + " a.timelink").clone();

  $("#quiz" + quiz_id).removeClass("Quiz")
                      .addClass("Answered")
                      .text(quiz_text)
                      .prepend(timelink);
}

var scrollToEvent = function(events) {
  if (userScrolling) return;
  var time = ytplayer.getCurrentTime();
  var here = 0;
  for(var i=0; i < events.length-1; i++) {
    if (events[i+1].start_time > time)
      break;
    here++;
  }


  var element = $("#events-area-student > div:eq(" + here + ")");
  var offset = -1*($("#content").height() - element.outerHeight())/2;
  if (offset > 0) offset = 0;

    
  $("#events-area-student").scrollTo(element, 500, { offset: offset });
}

var loadEvents = function(events) {
  var time = ytplayer.getCurrentTime();
  var currentId = getYoutubeID(ytplayer.getVideoUrl(), "v"); 

  var i = last_event + 1;

  if (hasJustEnded(waitingForTimeToEnd, time)) {
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
    waitingForTimeToEnd = events[last_event].end_time;
    waitingForTimeToSwitch = Number.MAX_VALUE;
  } else if (getYoutubeID(events[last_event+1].video_url, "v") != currentId) {
    // if we know the next event is a switch, we'll get ready for it
    waitingForTimeToSwitch = events[last_event].end_time;
    waitingForTimeToEnd = Number.MAX_VALUE;
  } else {
    waitingForTimeToSwitch = Number.MAX_VALUE;
    waitingForTimeToEnd = Number.MAX_VALUE;
  }

  //if (ytplayer.getPlayerState() == 2) return;
  //if (afterQuizBuffer) return;

  for (i = 0; i < events.length; i++) { 
    if (parseInt($("#quiz-id").text()) == events[i].id) continue;
    if (parseInt($("#response_quiz_id").val()) == events[i].id) continue;

    //console.log("For " + i + " diff is " + (ytplayer.getCurrentTime() - events[i].start_time));
    if (events[i].type == "Quiz" && getYoutubeID(events[i].video_url, "v") == currentId && hasJustEnded(events[i].start_time, time)) {
      ytplayer.pauseVideo();
      $("#quiz_area").load("/quizzes/" + events[i].id + "/ #study-area", prepareQuiz);
    }
  }


  //for (var top=0; events[top].start_time < time; top++) { }
}

var hasJustEnded = function(event_time, time) {
  return time - event_time >= 0 && time - event_time < 1.2;
}

var formatTime = function(time) {
  var str = "";
  str += Math.floor(time/60);
  str += ":";
  if (time % 60 < 10)
    str += "0" + time % 60;
  else 
    str += time % 60;
  console.log(str);
  return str;
};

var loadEvent = function(next_event) {
  var newdiv = $("<div />").addClass(next_event.type)
                           .addClass("event");
  //newdiv.data("time", next_event.start_time);
  var timelink = $("<a />").addClass("timelink")
                           .text(formatTime(next_event.start_time))
                           .attr("href", "#")
                           .click(function() {
                               ytplayer.seekTo(next_event.start_time - .6, true); });

  if (next_event.type == "Note") {
    newdiv.text(next_event.content)
  } else if (next_event.type == "Quiz") {
    newdiv.text("You have an unanswered quiz! ")
          .attr("id", "quiz" + next_event.id);

    var quizlink = $("<a />").attr("href", "#")
                             .text("Take quiz")
                             .click(function() { 
                                 //afterQuizBuffer = false; 
                                 ytplayer.pauseVideo();
                                 ytplayer.seekTo(next_event.start_time, true); 
                             })
                             .appendTo(newdiv);
  }
  newdiv.prepend(timelink);
  $("#events-area-student").append(newdiv);
}



