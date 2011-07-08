$(document).ready(function () {
    
    var updateInputForm = function() {
      $(".extra-form").hide();
      if ($("#quiz_answer_type option:selected").val() == 'fbd') { 
        $("#addanswerbutton").hide();
        $("#remove-answer").hide();
        $("#fbd_form").show();
        if (ff == null) {
          ff = new FBD;

          ff.loadJSONFBD({ "fb" :{"shape":"rect-line","top":80,"left":80,"width":162,"height":100,"radius":60,"rotation":-15,"cinterval":30}});
         }
      } else if ($("#quiz_answer_type option:selected").val() == 'multi') { 
          $("#multichoice_form").show();
          $("#addanswerbutton").hide();
          $("#remove-answer").hide();
      } else {
        $(".extra-form").hide();
        $("#addanswerbutton").show();
        $("#remove-answer").show();
      }
    };

    $("#quiz_answer_type").change(function() { 
      $("#quiz_answers_attributes_0_text").val("");
      $("#quiz_answer_input").val("");
      $("#quiz_answer_output").val("");
      updateInputForm();
    });

    $("#response_answer").keyup(function() {
      answer = $("#response_answer").val();
      if (answer == "") {
        $("#answer-morph").val("Don't know");
      } else {
        $("#answer-morph").val("Check answer");
      }
    });

    $("#choices input").keyup(function() {
        var inputJSON = getMCInputJSON();
        $("#quiz_answer_input").val(inputJSON);
      });

    ff = loadExistingFBD();

    updateInputForm();
});


var getMCInputJSON = function() {
  var str = '{ "type" : "multi", "choices" : [ ';
  var inputs = $("#choices input");
  var broken = false;
  inputs.each(function(i) {
    if ($(this).val() == "") broken = true;
    if (broken) return;
    str += '"' + $(this).val() + '", ';
  });
  str = str.replace(/, $/, "");
  str += "]}";
  return str;
};


var loadExistingFBD = function() {
    var ff = null;

    if ($("#holder").data("mode") == "student") {
      ff = new FBD;

      ff.loadJSONFBD($("#holder").data("json"));
    } else if ($("#holder").length != 0 && $("#quiz_answer_output").val() != "") {
      ff = new FBD;

      ff.loadJSONFBD($.parseJSON($("#quiz_answer_output").val()));
    }

    return ff;
}

function Force() {
  this.length = 110;
}


function FBD() {

  var canvas_width = 360;
  var canvas_height = 280;
  var paper = Raphael("holder", canvas_width, canvas_height);
  var border = paper.rect(1, 1, canvas_width - 2, canvas_height - 2);
  var selection_areas = [];
  var selection_radius = 8;  
  var surface_offset = 40;

  var waitingToBeginForce = true;
  var waitingToSetAngle = false;
  var selectAngle = false;
  var enableHolderClick = false;

  var answer = "";

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
  fb.cinterval = 30;  // number of degrees between selection points on circle
  var forces = [];

  var current_force = null;

  var assignAnswer = function(answerDiv) {
    var oi = answerDiv.parent().text().split(" ")[0];
    var a = answerDiv.parent().text().split(" ")[1];
    answer = oi + " " + a; 

    $('.quiz_answer_text').each(function() { $(this).parent().hide(); });
    $('.quiz_answer_text').first().parent().show();
    $('.quiz_answer_text').first().val(answer);

    $("#response_answer").val(answer);
    $(".force-item").removeClass("selected-answer");
    answerDiv.parent().addClass("selected-answer");
    $(".force-add-answer").text("Use as answer");
    answerDiv.text("Selected answer");

    updateJSON();
  };

  var displayForce = function(force) {


      var force_disp = $("<li>").text(force.origin_index + " " + force.angle + " ")
      .addClass("force-item");

      current_force = new Object();

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

        updateJSON();
        $(this).parent().hide();
        return false;
      });

      var add_answer = $("<a>")
        .text("Use as answer")
        .attr("href", "#")
        .css("margin-left", "8px")
        .addClass("force-add-answer")
        .click(function() {
            assignAnswer($(this));
            return false;
            });

      force_disp.append(remove_link);
      force_disp.append(add_answer);

      force_disp.appendTo($("#forces"));

      if (!$(".force-item").hasClass("selected-answer")) {
        assignAnswer($(".force-add-answer"));
      }
  };

  var init = function() {
    fb.cx = fb.top + fb.radius;
    fb.cy = fb.left + fb.radius;
    fb.obj = null;
    fb.extra = null;

    var existing_answer = null;
    if ($("#quiz_answers_attributes_0_text").length > 0 && $("#quiz_answers_attributes_0_text").val() != "") { 
      existing_answer = $("#quiz_answers_attributes_0_text").val();
    }

    // add each existing force to the displayed force list
    for (var i=0; i < forces.length; i++) {
      displayForce(forces[i]);
    }

    // select the answer that's being used
    if (existing_answer != null) {
      for (var i=1; i <= $(".force-item").length; i++) {
        if ($(".force-item:nth-child("+i+")").text().split(" ").slice(0,2).join(" ") == existing_answer) {
          assignAnswer($(".force-item:nth-child("+i+")").find(".force-add-answer"));
        }
      }
    }

    waitingToBeginForce = true;
    current_force = new Object();

    $("#rotate-select").val(fb.rotation);
    $('#fbd-select input[value="' + fb.shape + '"]').attr('checked', 'checked');
    $("#holder").click(function(f) {
        if (!waitingToSetAngle) return;
        
        waitingToSetAngle = false;
        waitingToBeginForce = true;

        forces.push(current_force);
        displayForce(current_force);

        updateJSON();

        return false;
    });

    $("#holder").mousemove(function(e) { 
        if (waitingToBeginForce) return; // don't care about the mouse if we're still picking the force

        var interval = Math.PI/12.0;
        var multiplier = 1.0/interval;    
        var offsets = getRelativeCoordinates(e, document.getElementById('holder'));
        var angle = Math.atan2(current_force.oy - offsets.y, offsets.x - current_force.ox);
        var rounded_angle = interval*Math.round(multiplier * angle);
        var angle_deg = Math.round(180.0/Math.PI * rounded_angle);

        var x_off = Math.cos(rounded_angle)*current_force.length;
        var y_off = -1.0*Math.sin(rounded_angle)*current_force.length;
        var newPath = ["M", current_force.ox,         current_force.oy,
        "L", current_force.ox + x_off, current_force.oy + y_off];

        current_force.angle = angle_deg;

        current_force.obj.rotate(-1*angle_deg, current_force.ox, current_force.oy);
        $('#status').html(angle_deg);
    });

    draw();
  };

  var drawArrow = function(ox, oy, angle) {
    var path = ["M", ox,            oy,
                "L", ox + 110,      oy,
                "L", ox + 110 - 10, oy + 5,
                "M", ox + 110,      oy,
                "L", ox + 110 - 10, oy - 5];

    var arrow = paper.path(path);
    arrow.attr({"stroke-width": 3, stroke: "#f33"});
    arrow.rotate(-1*angle, ox, oy);
    return arrow; 
  }

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

    
    for (var i=0; i < forces.length; i++) {
      if (!("obj" in forces[i])) {
        forces[i].obj = drawArrow(forces[i].ox, forces[i].oy, forces[i].angle);
      }
    }
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
    if ("obj" in current_force) current_force.obj.remove();

    current_force = new Object();

    for (var i=0; i < forces.length; i++) {
      forces[i].obj.remove();
    }
    forces = [];

    waitingToBeginForce = true;
    waitingToSetAngle = false;

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
      updateJSON();
      });

  var printSelectionPoints = function(pts){
    selection_areas = [];

    for (var i=0; i < pts.length; i++) {
      selection_areas.push(paper.circle(pts[i][0], pts[i][1], selection_radius));
      selection_areas[i].attr({ fill : "#66f" });
      selection_areas[i].attr({ "stroke-width": 0 });
      selection_areas[i].attr({ "fill-opacity": .5 });
      selection_areas[i].node.setAttribute("data-index",  i);
      selection_areas[i].node.setAttribute("class", "selection-area");
      selection_areas[i].click(function(event) {
          if (!waitingToBeginForce) return;
          if (waitingToSetAngle) return;

          waitingToBeginForce = false;
          setTimeout(function() { waitingToSetAngle = true; }, 150); // allow some time for the holder click to clear
          current_force.origin_index = this.node.getAttribute("data-index");

          var ox = parseInt(this.attr("cx"));
          var oy = parseInt(this.attr("cy"));

          current_force.origin = this; 
          var theta = fb.rotation * Math.PI/180;
          current_force.ox = (ox - centerx())*Math.cos(theta) - (oy - centery())*Math.sin(theta) + centerx();
          current_force.oy = (ox - centerx())*Math.sin(theta) + (oy - centery())*Math.cos(theta) + centery();

          current_force.obj = drawArrow(current_force.ox, current_force.oy, 0);
          });
    }

    return selection_areas;
  };

  $("#rotate-select").change(function() {
      if (fb.obj == null) return; 

      clearForces();

      fb.rotation = -1*$("#rotate-select option:selected").val();
      applyRotation();
      updateJSON();

      });


  this.loadDefaultFBD = function(){
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
    fb = data.fb;
    forces = data.forces || [];
    init();
  };


  var getInputJSON = function() { 
    return '{ "type" : "fbd", "fb" : ' + toJSONString(fb, ["shape", "top", "left", "width", "height", "radius", "rotation", "cinterval"]) + '}';
    };


  var getOutputJSON = function() {
    var forces_strings = [];

    for (var i=0; i < forces.length; i++) {
      forces_strings[i] = toJSONString(forces[i], ["origin_index", "ox", "oy", "angle"]);
    }

    var forces_json = "[" + forces_strings.join(", ") + "]";

    return '{ "type" : "fbd", "fb" : ' 
      + toJSONString(fb, ["shape", "top", "left", "width", "height", "radius", "rotation", "cinterval"])
        + ', "forces" : ' 
        + forces_json + '}';
  };

  var updateJSON = function() {
    $("#quiz_answer_input").val(getInputJSON());
    $("#quiz_answer_output").val(getOutputJSON());
  };
};

function toJSONString(obj, attrs) {
    var strings = [];

    for ( var i = 0; i<attrs.length ; i++) {
      if (typeof(obj[attrs[i]]) == "string") {
        strings[i] =  '"' + attrs[i] + '" : "' + obj[attrs[i]] + '"';
      } else {
        strings[i] = '"' + attrs[i] + '" : ' + obj[attrs[i]];
      }
    }

    return '{' + strings.join(", ") + '}';
  };

function getAbsolutePosition(element) {
    var r = { x: element.offsetLeft, y: element.offsetTop };
    if (element.offsetParent) {
      var tmp = getAbsolutePosition(element.offsetParent);
      r.x += tmp.x;
      r.y += tmp.y;
    }
    return r;
  };

  /**
   * Retrieve the coordinates of the given event relative to the center
   * of the widget.
   *
   * @param event
   *   A mouse-related DOM event.
   * @param reference
   *   A DOM element whose position we want to transform the mouse coordinates to.
   * @return
   *    A hash containing keys 'x' and 'y'.
   */
var getRelativeCoordinates = function(event, reference) {
  var x, y;
  event = event || window.event;
  var el = event.target || event.srcElement;

  if (!window.opera && typeof event.offsetX != 'undefined') {
    // Use offset coordinates and find common offsetParent
    var pos = { x: event.offsetX, y: event.offsetY };

    // Send the coordinates upwards through the offsetParent chain.
    var e = el;
    while (e) {
      e.mouseX = pos.x;
      e.mouseY = pos.y;
      pos.x += e.offsetLeft;
      pos.y += e.offsetTop;
      e = e.offsetParent;
    }

    // Look for the coordinates starting from the reference element.
    var e = reference;
    var offset = { x: 0, y: 0 }
    while (e) {
      if (typeof e.mouseX != 'undefined') {
        x = e.mouseX - offset.x;
        y = e.mouseY - offset.y;
        break;
      }
      offset.x += e.offsetLeft;
      offset.y += e.offsetTop;
      e = e.offsetParent;
    }

    // Reset stored coordinates
    e = el;
    while (e) {
      e.mouseX = undefined;
      e.mouseY = undefined;
      e = e.offsetParent;
    }
  }
  else {
    // Use absolute coordinates
    var pos = getAbsolutePosition(reference);
    x = event.pageX  - pos.x;
    y = event.pageY - pos.y;
  }
  // Subtract distance to middle
  return { x: x, y: y };
}
