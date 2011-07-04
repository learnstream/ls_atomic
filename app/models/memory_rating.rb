class MemoryRating < ActiveRecord::Base
  belongs_to :memory

  scope :ratings_between, lambda { |time_range| where(:created_at => time_range) }


  scope :in_course, lambda { |course_id| joins(:memory => :component).merge(Component.where( :course_id => course_id ))}
  scope :ratings_after, lambda { |stime| where("memory_ratings.created_at >= ?", stime)} 
  scope :ratings_before, lambda { |etime| where("memory_ratings.created_at <= ?", etime)} 
end

