class AddDefaultsToMemories < ActiveRecord::Migration
  def self.up
      change_column :memories, :ease, :decimal, {:default => 2.5}
      change_column :memories, :interval, :decimal, {:default => 1.0}
      change_column :memories, :views, :integer, {:default => 0}
      change_column :memories, :streak, :integer, {:default => 0}
      change_column :memories, :due, :datetime, {:default => Time.now}
  end

  def self.down
      change_column :memories, :interval, :integer
  end
end
