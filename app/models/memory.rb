class Memory < ActiveRecord::Base
  has_many :memory_ratings, :dependent => :destroy 
  
  belongs_to :user
  belongs_to :component

  before_create lambda { self.due = Time.now }

  scope :in_course, lambda { |course_id| joins(:component).merge(Component.where(:course_id => course_id)) }
  scope :due_now, where("due <= ?", Time.zone.now)
  default_scope :order => 'memories.due'  

  def course
    component.course
  end

  def view(quality)
    memory_rating = self.memory_ratings.build(:memory_id => self, :quality => quality)
    memory_rating.save

    self.views += 1
    self.last_viewed = Time.zone.now

    if quality < 3 
      self.streak = 0
    else
      self.streak += 1
    end

    new_ease = ease - 0.8 + 0.28*quality - 0.02*quality**2  
    if new_ease >= 1.3
      self.ease = new_ease 
    else
      self.ease = 1.3
    end

    if streak == 1
      self.interval = 1.0
    elsif streak == 2
      self.interval = 6.0
    elsif streak == 0
      self.interval = 0.0065
    else
      self.interval = interval*ease
    end

    self.due = Time.zone.now + interval.days
  end

  def reset
    self.views = 0
    self.streak = 0
    self.interval = 1.0
    self.ease = 2.5
    self.last_viewed = nil
    self.due = Time.zone.now
  end
end
