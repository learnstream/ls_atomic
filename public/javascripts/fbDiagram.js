
$(document).ready(function () {
  console.log("hiya");
  var paper = Raphael("holder", 320, 240);
  //var c = paper.circle(100, 100, 40);
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

    $("#holder").click(function(f) {
        if (!enableHolderClick) return;
        selectAngle = false;
        enableHolderClick = false;
        startedAngle = false;
        $('.selection-area').show();
      });


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

