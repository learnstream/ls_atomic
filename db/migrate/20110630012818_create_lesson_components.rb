class CreateLessonComponents < ActiveRecord::Migration
  def self.up
    create_table :lesson_components do |t|
      t.integer :lesson_id
      t.integer :component_id
      t.integer :event_id

      t.timestamps
    end

    add_index :lesson_components, :lesson_id
    add_index :lesson_components, :component_id
    add_index :lesson_components, [:lesson_id, :component_id], :unique => true
  end

  def self.down
    drop_table :lesson_components
  end
end
