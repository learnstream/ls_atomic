class AddPermissionsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :perm, :string, :default => "learner"
  end

  def self.down
    remove_column :users, :perm
  end
end
