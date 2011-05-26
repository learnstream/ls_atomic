class AddProblemToCourse < ActiveRecord::Migration
  def self.up
    add_column :problems, :course_id, :integer
  end

  def self.down
    remove_column :problems, :course_id
  end
end
