$(document).ready(function() { 
    var lessonId = $("#lesson-id").text();
    $.get('/lessons/' + lessonId + '/events.json', function(data) {
      for (var i=0; i < data.length; i++) {
        var newdiv = $("<div />");
        if (data[i].type == "Note") {
          newdiv.text(data[i].content)
                .addClass(data[i].type);

          $("#content").append(newdiv);
        } else {
          $("#quiz_area").load("/quizzes/" + data[i].id + "/ #study-area", prepareQuiz);
        }
      }
      var first = data[0];
      loadAndPlayVideo( getYoutubeID(first.video_url, "v"), first.start_time, 0, "player");
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
  response_html = $(data).find("#study-area").html();
  $("#quiz_area").html(response_html);
  $("#help").hide();
  $(".quizbutton").click(function() {
    var href = $(this).attr('href');
    $.get(href, function() { $("#quiz_area").html(""); });
    return false;
  });
};

