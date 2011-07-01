// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function () {
    var course_id = $('#course_id').text();

    var goToComponent = function(item) {
      console.log("asdf");
      console.log(item);
    };
      

    $('#quiz_component_tokens').tokenInput('/components.json?course_id=' + course_id,
      { 
        crossDomain: false,
        prePopulate: $('#quiz_component_tokens').data('pre')
      });

    $("#lesson_component_component_id").tokenInput('/components.json?course_id=' + course_id,
      { 
        crossDomain: false,
        tokenLimit: 1
      });


    $("#course_components").tokenInput('/components.json?course_id=' + course_id,
      { 
        hintText: "What do you want to know more about?",
        tokenLimit: 1
      });

    $("#component_help_link").click(function() {
        window.location.replace("/courses/" + course_id +  "/components/" + $("#course_components").val());
        });
  });

