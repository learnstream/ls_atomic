class RemoveDefaultRoleFromEnrollments < ActiveRecord::Migration
  def self.up
    change_column :enrollments, :role, :string, :default => nil
  end

  def self.down
    change_column :enrollments, :role, :string, :default => "student" 
  end
end
