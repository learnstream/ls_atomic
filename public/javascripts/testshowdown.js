$(document).ready(function() {
    converter = new Showdown.converter(); 
    console.log($("#explanation").html());
    $("#explanation").html(converter.makeHtml($("#explanation").text()));
});
