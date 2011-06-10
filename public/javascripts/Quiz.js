$(document).ready(function () {
//...

   ff = new FBD;

   ff.loadJSONFBD({"shape":"rect-line","top":80,"left":80,"width":162,"height":100,"radius":60,"rotation":-15,"cinterval":30});
  
   
  $("#add-force-begin").click(function() {
    ff.addNewForce();
  });
   
   $("#print-json").click(function(){
     console.log('JSON is:');
     console.log(ff.getJSONFBD());
   });

});

function Force() {
  this.length = 80;
}


function FBD() {
  
  var paper = Raphael("holder", 600, 350);
  var border = paper.rect(1, 1, 598, 348);
  var selection_areas = [];
  var selection_radius = 10;  
  var surface_offset = 40;
  var startedAngle = false;

  var startForce = false;
  var startAngle = false;
  var selectAngle = false;
  var enableHolderClick = false;
  
  // Initialize with some parameters...
  var fb = new Object;
  fb.shape = "rect";
  fb.top = 80;
  fb.left = 80;
  fb.width = 162;
  fb.height = 100;
  fb.radius = 60;
  fb.cx = fb.top + fb.radius;
  fb.cy = fb.left + fb.radius;
  fb.rotation = 0;
  fb.cinterval = 30; // number of degrees between selection points on circle


  var forces = [];
  var current_force = null;


  var init = function() {
    fb.cx = fb.top + fb.radius;
    fb.cy = fb.left + fb.radius;
    fb.obj = null;
    fb.extra = null;
    
    $("#rotate-select").val(fb.rotation);
    $('#fbd-select input[value="' + fb.shape + '"]').attr('checked', 'checked');
    $("#holder").click(function(f) {
        if (!enableHolderClick) return;
        
        startForce = false;
        enableHolderClick = false;
        startAngle = false;
        
        forces.push(current_force);
        
        var force_disp = $("<li>").text(current_force.origin_index + " " + current_force.angle + " ");

        var remove_link = $("<a>").text("Remove").attr("href", "#").click(function() {
          for (var i=0; i < forces.length; i++) {
            var f = forces[i];
            var oi = $(this).parent().text().split(" ")[0];
            var a = $(this).parent().text().split(" ")[1];
            if (f.origin_index == oi && f.angle == a) {
              forces[i].obj.remove();
              forces.splice(i, 1);
              break;
            }
          }
              
          $(this).parent().hide();
          });
        force_disp.append(remove_link);

        force_disp.appendTo($("#forces"));
        });


    $("#holder").mousemove(function(e) { 

        if (!startAngle) return;


        var interval = Math.PI/12.0;
        var multiplier = 1.0/interval;    
        var angle = Math.atan2(current_force.oy - e.pageY, e.pageX - current_force.ox);
        var rounded_angle = interval*Math.round(multiplier * angle);
        var angle_deg = Math.round(180.0/Math.PI * rounded_angle);

        var x_off = Math.cos(rounded_angle)*current_force.length;
        var y_off = -1.0*Math.sin(rounded_angle)*current_force.length;
        var newPath = ["M", current_force.ox,         current_force.oy,
        "L", current_force.ox + x_off, current_force.oy + y_off];


        current_force.angle = angle_deg;

        current_force.obj.attr({ path: newPath });
        $('#status').html(angle_deg);
        enableHolderClick = true; 


    });

    draw();
  };
  
  var draw = function() { 
    selection_areas = [];
    
    if (fb.shape == "rect"){
      fb.obj = paper.rect(fb.top, fb.left, fb.width, fb.height);     
      selection_areas = applySelectionPtsRect();
    } else if (fb.shape == "rect-line") {
      fb.obj = paper.rect(fb.top, fb.left, fb.width, fb.height);     
      var surface_path = ["M", fb.left - surface_offset,            fb.top + fb.height,
          "L", fb.left + fb.width + surface_offset, fb.top + fb.height];
      fb.extra = paper.path(surface_path);
      selection_areas = applySelectionPtsRect();
    } else if (fb.shape == "circle") {
      fb.obj = paper.circle(fb.cx, fb.cy, fb.radius);
      selection_areas = applySelectionPtsCirc();
    }

    applyRotation();

  };



  var applySelectionPtsRect = function() {

    var TLx = fb.obj.attr("x");
    var TLy = fb.obj.attr("y");

    var TRx = TLx + fb.width;
    var TRy = TLy;
    var BLx = TLx;
    var BLy = TLy + fb.height;
    var BRx = BLx + fb.width;
    var BRy = BLy;

    var pts = [];
    pts.push([TRx, TRy]);
    pts.push([TLx, TLy]);
    pts.push([BRx, BRy]);
    pts.push([BLx, BLy]);
    pts.push([(TRx + TLx)/2, TRy]);
    pts.push([(BRx + BLx)/2, BRy]);
    pts.push([TRx, (TRy + BRy)/2]);
    pts.push([TLx, (TLy + BLy)/2]);
    pts.push([(TRx + TLx)/2, (TRy + BRy)/2]);
    
    return printSelectionPoints(pts);
  };


  var applySelectionPtsCirc = function(){
    var pts = [];
    for (var i=0; i<360; i+= fb.cinterval){
      pts.push([fb.cx + fb.radius * Math.cos(i*Math.PI/180), 
                fb.cy + fb.radius * Math.sin(i*Math.PI/180)]);
    }
    pts.push([fb.cx, fb.cy]);
    
    return printSelectionPoints(pts);
  };


  var applyRotation = function() {

    var object_set = paper.set();
    object_set.push( fb.obj, fb.extra );
    for (var i=0; i < selection_areas.length; i++) {
      object_set.push(selection_areas[i]);
    }

    object_set.rotate(fb.rotation, centerx(), centery());
  };

  var centerx = function() {
   return (fb.shape == "circle") ? fb.cx : (2*fb.left + fb.width)/2;   
   }

   var centery = function() {
   return (fb.shape == "circle") ? fb.cy : (2*fb.top + fb.height)/2;
   }
 
  var clearShape = function() {
    if (fb.obj != null) fb.obj.remove();
    if (fb.extra != null) fb.extra.remove();
    
    for (var i=0; i < selection_areas.length; i++) {
      selection_areas[i].remove();
    }

    selection_areas = [];

    $("#rotate-select").val(0);
    fb.rotation = 0;
  };

  var clearForces = function() {
    if (current_force != null) current_force.obj.remove();

    for (var i=0; i < forces.length; i++) {
      forces[i].obj.remove();
    }
    forces = [];

    startForce = false;
    startAngle = false;
    $("#forces li").each(function() { 
      $(this).find("a").unbind('click'); 
      $(this).hide();
    });
  };

  $('#fbd-select :radio').click(function(e){
    clearShape();
    clearForces();
    fb.shape = $(this).val();
    draw();
    });

  var printSelectionPoints = function(pts){
    selection_areas = [];

    for (var i=0; i < pts.length; i++) {
      selection_areas.push(paper.circle(pts[i][0], pts[i][1], selection_radius));
      selection_areas[i].attr({ fill : "#fff"});
      selection_areas[i].node.setAttribute("data-index",  i);
      selection_areas[i].node.setAttribute("class", "selection-area");
      selection_areas[i].click(function(event) {
        if (!startForce) return;
        if (startAngle) return;

        startAngle = true; 
        current_force.origin_index = this.node.getAttribute("data-index");

        var ox = parseInt(this.attr("cx"));
        var oy = parseInt(this.attr("cy"));

        current_force.origin = this; 
        var theta = fb.rotation * Math.PI/180;
        current_force.ox = (ox - centerx())*Math.cos(theta) - (oy - centery())*Math.sin(theta) + centerx();
        current_force.oy = (ox - centerx())*Math.sin(theta) + (oy - centery())*Math.cos(theta) + centery();
        console.log(current_force.length);
        var initPath = ["M", current_force.ox,         current_force.oy,
                        "L", current_force.ox + current_force.length, current_force.oy];
        current_force.obj = paper.path(initPath);
        current_force.obj.attr({"stroke-width": 3, stroke: "#f33"});
      });
    }

    return selection_areas;
  };

  $("#rotate-select").change(function() {
    if (fb.obj == null) return; 
  
    clearForces();

    fb.rotation = -1*$("#rotate-select option:selected").val();
    applyRotation();

  });
  

  this.loadDefaultFBD = function(){
     console.log('Loading default FBD');

        // These are the FBD properties... load!!
     fb.shape = "rect";
     fb.top = 80;
     fb.left = 80;
     fb.width = 162;
     fb.height = 100;
     fb.radius = 60;
     fb.rotation = 0;
     fb.cinterval = 30; // number of degrees between selection points on circle
     
     // Now, call init() to prepare the canvas
     init();  
  };

  this.loadJSONFBD = function(data){
    fb = data;
    init();
  };
  
  
  this.getJSONFBD = function(){
    return fb.toJSONString(["shape", "top", "left", "width", "height", "radius", "rotation", "cinterval"])
  };

  this.addNewForce = function() {
    current_force = new Force();
    startForce = true;
  }
};

