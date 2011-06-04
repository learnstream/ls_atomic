$(document).ready(function(){
  var course_id = $("#stats-course-id").text();
  build_chart(course_id);
  
});


var build_chart = function(course_id){
   var tick_label = [ [2, "4 weeks"], [9,"3 weeks"] ,[16,"2 weeks"], [23,"1 week"], [30, "now"]];
    //var tick_label = [[1, "week"]];
  $.get("/courses/" + course_id + "/stats/", function(data) {
    $.plot($("#stat-chart"), data.stats, { yaxis: { max: 1, min: 0, tickSize: .2 }, xaxis: {max: 30, min: 0, ticks: tick_label} });
  });
}
