class AddMoreStatsToMemoryRatings < ActiveRecord::Migration
  def self.up
    add_column :memory_ratings, :streak, :integer
    add_column :memory_ratings, :ease, :decimal
    add_column :memory_ratings, :interval, :integer
  end

  def self.down
    remove_column :memory_ratings, :streak
    remove_column :memory_ratings, :ease
    remove_column :memory_ratings, :interval
  end
end
