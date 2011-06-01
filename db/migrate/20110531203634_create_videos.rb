class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :url
      t.integer :start_time, :default => 0
      t.integer :end_time
      t.string :name
      t.integer :component_id

      t.timestamps
    end
    add_index :videos, :component_id
  end

  def self.down
    drop_table :videos
  end
end
