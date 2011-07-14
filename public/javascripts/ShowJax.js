$(document).ready(function() {
   $(".markdown").each(function() { $(this).markdown(); });
});

$.fn.markdown = function(typeset) {
  mathDiv = this.selector.slice(1);
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
    console.log("Text: " + $(this).text());
    if($(this).text() != "") {
      MathJax.Hub.Queue(["Typeset", MathJax.Hub, $(this).attr("id")]);
      console.log("ID: " + $(this).attr("id"));
    }
  });

}

$.fn.markdownInner = function() {
  $(this).find(".markdown").each(function() {
      $(this).markdown(false); });
  MathJax.Hub.Queue(["Typeset", MathJax.Hub, mathDiv]);
}
