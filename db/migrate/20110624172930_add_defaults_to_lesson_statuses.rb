class AddDefaultsToLessonStatuses < ActiveRecord::Migration
  def self.up
    change_column :lesson_statuses, :event_id, :integer, :default => -1
    change_column :lesson_statuses, :completed, :boolean, :default => false
  end

  def self.down
    change_column :lesson_statuses, :event_id, :integer, :default => nil
    change_column :lesson_statuses, :completed, :boolean, :default => nil
  end
end
