class AddDefaultToRoleInEnrollments < ActiveRecord::Migration
  def self.up
    change_column :enrollments, :role, :string, { :default => "student" }
  end

  def self.down
    change_column :enrollments, :role, :string
  end
end
