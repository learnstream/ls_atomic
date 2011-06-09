$(document).ready(function(){
  var course_id = $("#stats-course-id").text();
  build_success_chart(course_id);
  build_cards_due_chart(course_id);
  build_achievement_chart(course_id);

  $("td").hover(function() {
      $(this).find("div").show();
    }, 
    function() {
      $(this).find("div").hide(); 
    });
});


var build_success_chart = function(course_id){
   var tick_label = [ [0, "4 weeks"], [7,"3 weeks"] ,[14,"2 weeks"], [21,"1 week"], [28, "now"]];
  $.get("/courses/" + course_id + "/success_stats.json", function(data) {
    $.plot($("#stat-chart"), data.success_stats, { yaxis: { min: 0 }, xaxis: {max: 28, min: 0, ticks: tick_label}, series: { lines: { lineWidth: 0 }}, colors: [ "rgba(0,0,225,0.8)", "rgba(0,225,0,0.8)"], legend: { backgroundOpacity: 0, backgroundColor: null,noColumns: 2, position: "nw", margin: [0,-30] }} );
  });
}

var build_cards_due_chart = function(course_id){
  var tick_label = [ [0, "today"], [7,"1 weeks"] ,[14,"2 weeks"], [21,"3 weeks"]] ;
  $.get("/courses/" + course_id + "/cards_due_stats.json", function(data) {
    $.plot($("#cards-due-chart"), data.cards_due_stats, { yaxis: { min: 0 }, xaxis: {max: 21, min: 0, ticks: tick_label}, series: { lines: {fill: true}} });
  });
}

var build_achievement_chart = function(course_id){
  
  $.get("/courses/" + course_id + "/course_achieved_stats.json", function(data) {
    $.plot($("#achievement-chart"), data.course_achieved_stats, { yaxis: { min: 0, max: 1}, xaxis: {ticks: achievementTicks} });
  });
}

function achievementTicks(axis) {
  console.log(axis);
  var res = [];
  var num = 4;
  res.push([axis.max, "Today"]);
  for(var i = axis.max; i > axis.min;) {
    i -= Math.ceil(axis.max/num);
    console.log(i);
    res.push([i, axis.max - i + " days ago"]);
  }
  return res;
}
