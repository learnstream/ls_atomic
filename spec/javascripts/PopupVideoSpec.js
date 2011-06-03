describe("Study", function() {

    beforeEach(function() {
      loadFixtures("PopupVideo.html");
      var video_data = [ { "name" : "Cats",
                           "url" : "http://www.youtube.com/watch?v=nTasT5h0LEg",
                           "start_time" : 30,
                           "end_time" : 40,
                           "description" : "" }];

      var old_html = $('#help-items-videos').html();
      var watch_link = constructColorBoxLink(video_data[0], 0);

      $('#help-items-videos').html(old_html + watch_link);
    });
     
    it("should load the video when user clicks 'Watch'", function() {
      expect($('#video-watch-link-0')).toExist();
      $('#video-watch-link-0').click();
      expect(ytplayer).not.toBeNull();
      expect(blah).toEqual(123);
    });
  });

describe("YouTubeEmbed", function() {

    it("should be able to create links to embeddable Youtube", function() {
      var url = createYoutubeURL('nTasT5h0LEg', '30');
      expect(url).toEqual('http://www.youtube.com/v/nTasT5h0LEg&enablejsapi=1&playerapiid=player1&autoplay=1&start=30');
      });
    });
