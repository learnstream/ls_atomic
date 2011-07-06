$(document).ready(function() {
   $(".markdown").each(function() { $(this).markdown(); });
});

$.fn.markdown = function(typeset) {
  console.log($(this));
  converter = new Showdown.converter();
  $(this).html(converter.makeHtml($(this).text()));
  if (typeof(typeset) == "undefined" || typeset == true)
    MathJax.Hub.Typeset();
}

$.fn.markdownInner = function() {
  $(this).find(".markdown").each(function() {
      $(this).markdown(false); });
  MathJax.Hub.Typeset();
}
