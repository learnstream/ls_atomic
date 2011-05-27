class CreateMemoryRatings < ActiveRecord::Migration
  def self.up
    create_table :memory_ratings do |t|
      t.integer :memory_id
      t.integer :quality

      t.timestamps
    end

    add_index :memory_ratings, :memory_id
  end

  def self.down
    drop_table :memory_ratings
  end
end
