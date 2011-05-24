class UserSession < ActiveRecord::Base
  def to_key
    [session_key]
  end
end
