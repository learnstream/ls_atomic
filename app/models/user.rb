class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::MD5
    config.logged_in_timeout = 1.year
  end


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence => true,
                    :format   => { :with => email_regex }
end
