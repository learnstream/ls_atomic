class AddCourseIndexToComponent < ActiveRecord::Migration
  def self.up
    add_column :components, :course_id, :integer
    add_index :components, :course_id
  end

  def self.down
    remove_column :components, :course_id
    remove_index :components, :course_id
  end
end
