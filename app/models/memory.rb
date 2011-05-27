class Memory < ActiveRecord::Base

  has_many :memory_ratings, :dependent => :destroy 

  def view(quality)
    memory_rating = self.memory_ratings.build(:memory_id => self, :quality => quality)
    memory_rating.save

    self.views += 1

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

    self.due += interval.days
  end
end
