class CreateMemories < ActiveRecord::Migration
  def self.up
    create_table :memories do |t|
      t.integer :user_id
      t.integer :component_id
      t.decimal :ease
      t.integer :interval
      t.integer :views
      t.integer :streak
      t.datetime :last_viewed
      t.datetime :due

      t.timestamps
    end

    add_index :memories, :user_id
    add_index :memories, :component_id
    add_index :memories, [:user_id, :component_id], :unique => true
  end

  def self.down
    drop_table :memories
  end
end
