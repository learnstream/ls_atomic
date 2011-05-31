class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :url
      t.integer :start_time, :default => 0
      t.integer :end_time
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
