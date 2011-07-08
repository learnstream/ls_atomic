Rails.application.config.middleware.use OmniAuth::Builder do
  case Rails.env
  when "development"
    provider :twitter, 'W0XdUpc8SZaUZ48lTZnxg', 'qoq24DUG3T6dddtf4E20n78wdmHVud6DpiGQGJHty4'
    provider :facebook, '143168212426941', '186bbed08646b7ddd0cc765c3fd13371'
  when "production"
    provider :twitter, ENV["CONNECT_TWITTER_KEY"], ENV["CONNECT_TWITTER_SECRET"]
    provider :facebook, ENV["CONNECT_FACEBOOK_KEY"], ENV["CONNECT_FACEBOOK_SECRET"]
  end
end
