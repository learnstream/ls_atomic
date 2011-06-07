module VideosHelper


  def video_link(video)
    videoID = get_youtube_id(video.url, 'v')
    name = video.name || "Watch"
    link_to name, "#", :class => "color-box-link", 
                       'data-url' => videoID, 
                       'data-start-time' => video.start_time,
                       'data-end-time' => video.end_time
  end

  def get_youtube_id(url, name)
    urlparts = url.split('?')
    if(urlparts.length > 1)
      parameters = urlparts[1].split('&')
      parameters.each { |param|
        paramparts = param.split('=')
        if ((paramparts.length > 1) && (CGI.unescape(paramparts[0]) == name))
         return CGI.unescape(paramparts[1])
        end
      }
    end
    return nil
  end
end
