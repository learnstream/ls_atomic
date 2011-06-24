class CreateLessonStatuses < ActiveRecord::Migration
  def self.up
    create_table :lesson_statuses do |t|
      t.integer :lesson_id
      t.integer :user_id
      t.integer :event_id
      t.boolean :completed

      t.timestamps
    end

    add_index :lesson_statuses, :lesson_id
    add_index :lesson_statuses, :user_id
    add_index :lesson_statuses, :event_id
    add_index :lesson_statuses, [:lesson_id, :user_id], :unique => true
  end

  def self.down
    drop_table :lesson_statuses
  end
end
