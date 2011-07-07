case Rails.env
when "development"
  AuthlogicConnect.config = YAML.load_file("config/authlogic.yml")
when "production"
  AuthlogicConnect.config = {
    :connect => {
      :facebook => {
        :key => ENV["CONNECT_FACEBOOK_KEY"],
        :secret => ENV["CONNECT_FACEBOOK_SECRET"],
        :label => "Facebook"
      },
      :twitter => {
        :key => ENV["CONNECT_TWITTER_KEY"],
        :secret => ENV["CONNECT_TWITTER_SECRET"],
        :label => "Twitter"
      }
    }
  }
end

