class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  has_many :enrollments, :dependent => :destroy

  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::MD5
    config.logged_in_timeout = 1.year
  end

end
