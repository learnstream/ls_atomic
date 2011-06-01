// name is 'v' for youtube videos... pulls out parameter.
function getYoutubeID(url, name) {
    var urlparts = url.split('?');
    if (urlparts.length > 1) {
        var parameters = urlparts[1].split('&');
        for (var i = 0; i < parameters.length; i++) {
            var paramparts = parameters[i].split('=');
            if (paramparts.length > 1 && unescape(paramparts[0]) == name) {
                return unescape(paramparts[1]);
            }
        }
    }
    return null;
}

$(document).ready(function(){

var videoURL = $("#video-embed-url").text();
var videoID = getYoutubeID(videoURL, 'v'); 
var videoStart = $("#video-start-time").text();
var params = { allowScriptAccess: "always" };
var atts = { id: "ytPlayer" };
swfobject.embedSWF("http://www.youtube.com/v/" + videoID + "&enablejsapi=1&playerapiid=player1&start=" + videoStart, 
                   "video-embed-area", "480", "295", "8", null, null, params, atts); 

});

