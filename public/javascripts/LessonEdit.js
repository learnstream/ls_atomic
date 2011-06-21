$(document).ready(function() {
    var defaultUrl ="http://www.youtube.com/watch?v=7MqkEZn8pN4"; 
    
    loadAndPlayVideo(getYoutubeID(defaultUrl, "v"), 0, 0, "video-player", 0);

    $("#load-video").click(function() {
      var video_url = $("#load_video_url").val();
      var video_id = getYoutubeID(video_url, 'v');
      $("#current_video_url").text('Video URL: ' + video_url.split('&')[0]);
      loadAndPlayVideo(video_id, 0, 0, "video-player", 0);
      return false;
    });


    $("#lesson-edit-tabs").tabs();
    prepareQuizFirst();
    prepareNoteNew();
    $("#quiz_new_event_attributes_video_url").val(defaultUrl);
    $("#note_new_event_attributes_video_url").val(defaultUrl);
});


function prepareQuizFirst() {
  $("#quiz_new_event_attributes_lesson_id").val($("#lesson_id").text());
  $("#new_quiz").attr('data-remote', 'true');
    
  createSyncLinks();
}

function prepareQuizNew() { 
  $("#quiz_new_event_attributes_lesson_id").val($("#lesson_id").text());
  if (ytplayer != null)
    $("#quiz_new_event_attributes_video_url").val(ytplayer.getVideoUrl());
   
  $("#new_quiz").attr('data-remote', 'true');

  $('#quiz_component_tokens').tokenInput('/components.json?course_id='+$("#course_id").text(), 
  { 
      crossDomain: false,
      prePopulate: $('#quiz_component_tokens').data('pre')
  });
  $("a[href=#add-quiz]").text('Add Quiz');
  $("#lesson-edit-tabs").tabs('enable', 0);
    
  createSyncLinks();
}

function prepareQuizEdit(quiz_id) {
  $("#lesson-edit-tabs").tabs('select', 1);
  $("a[href=#add-quiz]").text('Edit Quiz');   
  $("#lesson-edit-tabs").tabs('disable', 0);  
  $("#quiz_existing_event_attributes_lesson_id").val($("#lesson_id").text());
  if (ytplayer != null)
    $("#quiz_existing_event_attributes_video_url").val(ytplayer.getVideoUrl());

  $("#edit_quiz_" + quiz_id).attr('data-remote', 'true');

  $('#quiz_component_tokens').tokenInput('/components.json?course_id=' + $("#course_id").text(), 
  { 
      crossDomain: false,
      prePopulate: $('#quiz_component_tokens').data('pre')
  });

  seekToEvent($("#quiz-" + quiz_id));
  createSyncLinks();
}

function prepareNoteNew() {
  $("#note_new_event_attributes_lesson_id").val($("#lesson_id").text());
  if (ytplayer != null)
    $("#note_new_event_attributes_video_url").val(ytplayer.getVideoUrl());
  $("a[href=#add-note]").text('Add Note');
  $("#lesson-edit-tabs").tabs('enable', 1);
  createSyncLinks();
}

function prepareNoteEdit(note_id) {
  $("#lesson-edit-tabs").tabs('select', 0);
  $("a[href=#add-note]").text('Edit Note');   
  $("#lesson-edit-tabs").tabs('disable', 1);  
  $("#note_existing_event_attributes_lesson_id").val($("#lesson_id").text());
  if (ytplayer != null)
    $("#note_existing_event_attributes_video_url").val(ytplayer.getVideoUrl());
  seekToEvent($("#note-" + note_id));
  createSyncLinks();
}

function seekToEvent(event_div) {
  var start_time = event_div.find(".data").attr('data-start_time');
  var video_id = getYoutubeID(event_div.find(".data").attr('data-video'), 'v');
  $("#load_video_url").val(event_div.find(".data").attr("data-video").split('&')[0]);
  $(".current_video_url").text("Video URL: " + event_div.find(".data").attr("data-video").split('&')[0]);

  if (video_id == getYoutubeID(ytplayer.getVideoUrl(), 'v')) {
    ytplayer.seekTo(start_time, true);
  } else {
    loadAndPlayVideo(video_id, start_time, 0, "video-player", 1);
  }
}

function createSyncLinks() {
    $(".start-sync").click(function(){
        var time = parseInt(ytplayer.getCurrentTime());
        $("#add-quiz .start_time").val(time);
        $("#add-note .start_time").val(time);
        return false;
    });

    $(".end-sync").click(function(){
        var time = parseInt(ytplayer.getCurrentTime());
        $("#add-quiz .end_time").val(time);
        $("#add-note .end_time").val(time);
        return false;
    });
}
