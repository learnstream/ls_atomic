class StopRequiringSingleAccessToken < ActiveRecord::Migration
  def self.up
    change_column :users, :single_access_token, :string, :default => nil, :null => true
  end

  def self.down
    change_column :users, :single_access_token, :string, :null => false
  end
end
