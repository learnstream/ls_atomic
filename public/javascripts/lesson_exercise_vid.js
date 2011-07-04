$(document).ready(function() {
    console.log("asdf");
    loadAndPlayVideo(getYoutubeID($("#player").attr("data-url"), "v"), $("#player").attr("data-starttime"), $("#player").attr("data-endtime"), "player", 0);
});
