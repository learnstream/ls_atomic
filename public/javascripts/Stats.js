$(document).ready(function(){
  var course_id = $("#stats-course-id").text();
  build_success_chart(course_id);
  build_cards_due_chart(course_id);
  build_achievement_chart(course_id);
});


var build_success_chart = function(course_id){
   var tick_label = [ [2, "4 weeks"], [9,"3 weeks"] ,[16,"2 weeks"], [23,"1 week"], [30, "now"]];
    //var tick_label = [[1, "week"]];
  $.get("/courses/" + course_id + "/success_stats.json", function(data) {
    $.plot($("#stat-chart"), data.success_stats, { yaxis: { max: 1, min: 0, tickSize: .2 }, xaxis: {max: 30, min: 0, ticks: tick_label} });
  });
}

var build_cards_due_chart = function(course_id){
  $.get("/courses/" + course_id + "/cards_due_stats.json", function(data) {
    $.plot($("#cards-due-chart"), data.cards_due_stats, { yaxis: { min: 0 }, xaxis: {max: 21, min: 0} });
  });
}

var build_achievement_chart = function(course_id){
   var tick_label = [ [2, "4 weeks"], [9,"3 weeks"] ,[16,"2 weeks"], [23,"1 week"], [30, "now"]];
    //var tick_label = [[1, "week"]];
  $.get("/courses/" + course_id + "/course_achieved_stats.json", function(data) {
    $.plot($("#achievement-chart"), data.course_achieved_stats, { yaxis: { max: 1, min: 0, tickSize: .2 } });
  });
}
