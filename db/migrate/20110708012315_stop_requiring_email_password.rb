class StopRequiringEmailPassword < ActiveRecord::Migration
  def self.up
    change_column :users, :email, :string, :default => nil, :null => true
    change_column :users, :crypted_password, :string, :default => nil, :null => true
    change_column :users, :password_salt, :string, :default => nil, :null => true
  end

  def self.down
    change_column :users, :email, :string, :null => false
    change_column :users, :crypted_password, :string, :null => false
    change_column :users, :password_salt, :string, :null => false
  end
end
