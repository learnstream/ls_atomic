class CreateEnrollments < ActiveRecord::Migration
  def self.up
    create_table :enrollments do |t|
      t.integer :user_id
      t.integer :course_id
      t.string :role

      t.timestamps
    end
    add_index :enrollments, :user_id
    add_index :enrollments, :course_id
    add_index :enrollments, [:user_id, :course_id], :unique => true
  end

  def self.down
    drop_table :enrollments
  end
end
