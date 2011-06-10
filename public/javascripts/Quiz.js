$(document).ready(function () {
//...

   ff = new FBD;
   ff.loadJSONFBD({"shape":"rect-line","top":80,"left":80,"width":162,"height":100,"radius":60,"rotation":-15,"cinterval":30});
  
   var x = ff.getJSONFBD();
   
   
   $("#print-json").click(function(){
     console.log('JSON is:');
     console.log(ff.getJSONFBD());
   });
   
});




function FBD() {
  
  var paper = Raphael("holder", 600, 350);
  var border = paper.rect(1, 1, 598, 348);
  var fb = new Object;
  var selection_areas = [];
  var selection_radius = 10;  
  var surface_offset = 40;

  var init = function() {
    fb.cx = fb.top + fb.radius;
    fb.cy = fb.left + fb.radius;
    fb.obj = null;
    fb.extra = null;
    
    $("#rotate-select").val(fb.rotation);
    $('#fbd-select input[value="' + fb.shape + '"]').attr('checked', 'checked');
    
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
    
    var centerx = (fb.shape == "circle") ? fb.cx : (2*fb.left + fb.width)/2;
    var centery = (fb.shape == "circle") ? fb.cy : (2*fb.top + fb.height)/2;

    var object_set = paper.set();
    object_set.push( fb.obj, fb.extra );
    for (var i=0; i < selection_areas.length; i++) {
      object_set.push(selection_areas[i]);
    }

    object_set.rotate(-1*fb.rotation, centerx, centery);
  };
 
  var cleanup = function() {
    if (fb.obj != null) fb.obj.remove();
    if (fb.extra != null) fb.extra.remove();
    selection_areas = [];
    $(".selection-area").remove();
    $("#rotate-select").val(0);
    fb.rotation = 0;
  };

  $('#fbd-select :radio').click(function(e){
    cleanup();
    fb.shape = $(this).val();
    draw();
    });

  var printSelectionPoints = function(pts){
    selection_areas = [];

    for (var i=0; i < pts.length; i++) {
      selection_areas.push(paper.circle(pts[i][0], pts[i][1], selection_radius));
      selection_areas[i].node.setAttribute("class", "selection-area");
    }

    return selection_areas;
  };

  $("#rotate-select").change(function() {
    if (fb.obj == null) return; 
  

    fb.rotation = $("#rotate-select option:selected").val();
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

};

