class CourseDescriptionToText < ActiveRecord::Migration
  def self.up
    change_column :courses, :description, :text, :limit => nil
  end

  def self.down
    change_column :courses, :description, :string
  end
end
