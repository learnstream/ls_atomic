$(document).ready(function() {
   $(".markdown").each(function() { $(this).markdown(); });
});

$.fn.markdown = function(typeset) {
  // It appears to typeset the whole page if it doesn't find the ID. Which
  // works, but isn't all that great.
  mathDiv = ($(this).attr("id"));
  converter = new Showdown.converter();
  $(this).html(converter.makeHtml($(this).text()));
  if (typeof(typeset) == "undefined" || typeset == true) {
    MathJax.Hub.Queue(["Typeset", MathJax.Hub, mathDiv]);
    typesetStubbornMath();
  }
}

// Render the bits of math that have inexplicably still failed to render, while
// leaving the rest alone. (If you try to typeset the whole page, it will break
// other things). 
function typesetStubbornMath() {
  $(".MathJax_Preview").each( function() {
    if($(this).text() != "") {
      MathJax.Hub.Queue(["Typeset", MathJax.Hub, $(this).attr("id")]);
    }
  });

}

$.fn.markdownInner = function() {
  $(this).find(".markdown").each(function() {
      $(this).markdown(false); });
  MathJax.Hub.Queue(["Typeset", MathJax.Hub, mathDiv]);
  typesetStubbornMath();
}
