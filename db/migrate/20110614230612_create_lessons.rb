class CreateLessons < ActiveRecord::Migration
  def self.up
    create_table :lessons do |t|
      t.string :name
      t.integer :course_id
      t.integer :order_number

      t.timestamps
    end
    add_index :lessons, :course_id
  end

  def self.down
    drop_table :lessons
  end
end
