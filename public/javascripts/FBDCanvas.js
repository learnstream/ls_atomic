$(document).ready(function () {
var paper = Raphael("holder", 600, 350);
var border = paper.rect(1, 1, 598, 348);
var sidebar = paper.rect(490, 10, 100, 330)
// Include sidebar things
// Draw permissions

var draw_mode = "rect";
var drawing = false;
var current_rect = [0, 0, 0, 0];

  $("#holder").click(function(f) {

    if (draw_mode == "rect") {
      if (drawing == false){
        drawing = true;
        current_rect[0] = f.pageX;
        current_rect[1] = f.pageY;
      } else {
        drawing = false;
        current_rect[2] = f.pageX - current_rect[0];
        current_rect[3] = f.pageY - current_rect[1];
        paper.rect(current_rect[0], current_rect[1], current_rect[2], current_rect[3]);
      }
    }




   });

$("#holder").mousemove(function(e) { 
  $("#pos").text(current_rect.toString());
});





var freebody = paper.rect(80, 80, 100, 100);

var selection_pts = [[130, 130], [80, 80], [80, 180], [180, 80], [180,180]];
var selection_areas = [];
var selection_radius = 15;

for (var i = 0; i < selection_pts.length; i++) {
  selection_areas.push(paper.circle(selection_pts[i][0], selection_pts[i][1], selection_radius));
  selection_areas[i].attr({fill: "blue"});
  selection_areas[i].node.setAttribute("class", "selection-area");
  
}

var length = 60;
var enableHolderClick = false;
var selectAngle = false;
var startedAngle = false;

var ox = 0;
var oy = 0;

var force = null;

$('.selection-area').click(function() {
  if (startedAngle) return;
  startedAngle = true; 
  $('.selection-area').hide();

  ox = parseInt($(this).attr("cx"));
  oy = parseInt($(this).attr("cy"));

  var initPath = ["M", ox,          oy,
                  "L", ox + length, oy]

  force = paper.path(initPath);

  selectAngle = true;

 
});

});
/* 
$("#holder").mousemove(function(e) { 
  if (!selectAngle) return;
  var interval = Math.PI/12.0;
  var multiplier = 1.0/interval;    
  var angle = Math.atan2(oy - e.pageY, e.pageX - ox);
  var rounded_angle = interval*Math.round(multiplier * angle);
  var angle_deg = Math.round(180.0/Math.PI * rounded_angle);


  var x_off = Math.cos(rounded_angle)*length;
  var y_off = -1.0*Math.sin(rounded_angle)*length;


  var newPath = ["M", ox,         oy,
                 "L", ox + x_off, oy + y_off];
  
  force.attr({ path: newPath });
  $('#status').html(angle_deg);
  enableHolderClick = true; 
});
*/
