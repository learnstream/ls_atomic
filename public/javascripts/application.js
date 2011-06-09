// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function () {
    var course_id = $('#course_id').text();
    $('#step_component_tokens').tokenInput('/components.json?course_id=' + course_id, { 
      crossDomain: false,
      prePopulate: $('#step_component_tokens').data('pre')
    });

    $('#quiz_component_tokens').tokenInput('/components.json?course_id=' + course_id,
      { 
        crossDomain: false,
        prePopulate: $('#quiz_component_tokens').data('pre')
      });
  });
