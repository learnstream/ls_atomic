class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :lesson_id
      t.integer :playable_id
      t.string :playable_type
      t.string :video_url
      t.integer :start_time
      t.integer :end_time
      t.integer :order_number

      t.timestamps
    end
    add_index :events, :lesson_id
    add_index :events, [ :playable_type, :playable_id ]
  end

  def self.down
    drop_table :events
  end
end
