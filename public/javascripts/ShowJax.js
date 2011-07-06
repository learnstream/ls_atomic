$(document).ready(function() {
    var fields = jQuery.parseJSON($("#markdown-fields").text());
    for (i=0 ; i<fields.length; i++) {
      renderField(fields[i]);
    }
});

var renderField = function (field) {
  converter = new Showdown.converter(); 
  $(field).html(converter.makeHtml($(field).text()));
}

var renderFields = function (field) {
  converter = new Showdown.converter(); 
  $(field).each(function () {
      html(converter.makeHtml($(this).html()));
  });
}
