class Memory < ActiveRecord::Base
  has_many :memory_ratings, :dependent => :destroy 
  
  belongs_to :user
  belongs_to :component

  before_create lambda { self.due = Time.now }

  scope :in_course, lambda { |course_id| joins(:component).merge(Component.where(:course_id => course_id)) }
  scope :due_before, lambda { |time| where("due <= ? AND views > 0", time) }
  scope :latest_studied, :order => 'last_viewed DESC'
  scope :viewed, where('views > ?', 0)
  scope :reviewed_today, joins(:component => {:quizzes => :responses}).merge(Response.where('responses.created_at >= ? AND responses.created_at <= ?', DateTime.now.utc.beginning_of_day, DateTime.now.utc)).group('memories.id')

  scope :course_exercise, lambda { |course_id| in_course(course_id).due_before(DateTime.now.utc).viewed }

  default_scope :order => 'memories.views > 0 DESC, memories.due'  

  def course
    component.course
  end
  
  def due?
    return self.due <= Time.now.utc
  end
  
  def viewed?
    return !last_viewed.nil?
  end

  def has_quiz?
    return component.quizzes.length != 0
  end

  def has_exercise?
    return component.quizzes.exercises.length != 0
  end

  def view(quality)

    if (quality > 5 || quality < 0)
      return
    end

    self.views += 1
    self.last_viewed = Time.now

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

    #self.due = Time.now + interval.days
    self.due = Time.now + (interval * 24 * 60 * 60).round

    self.save()

    memory_rating = self.memory_ratings.build(:memory_id => self, :quality => quality,
                                              :streak => streak, :interval => interval,
                                              :ease => ease)
    memory_rating.save
    return true
  end

  def skip!
    self.views += 1
    self.last_viewed = Time.now
    self.due = Time.now + 1.day
    self.save
  end

  def reset
    self.views = 0
    self.streak = 0
    self.interval = 1.0
    self.ease = 2.5
    self.last_viewed = nil
    self.due = Time.now
    self.save
  end

  def remove!
    self.due = DateTime.now + 1000.years
    self.save
  end

  def removed?
    due >= (DateTime.now + 900.years)
  end

  def unlock!
    self.views += 1
    self.last_viewed = Time.now
    self.save
  end
    
end
