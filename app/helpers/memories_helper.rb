module MemoriesHelper

  def strength(memory)
    if memory.removed?
      return "Not being studied"
    elsif not memory.viewed?
      return "Not started"
    elsif memory.due?
      return "Needs review"
    elsif memory.interval > 30
      return "Strong"
    elsif memory.interval >= 7
      return "Medium"
    else
      return "Weak" 
    end
  end

  def strength_class(memory)
    strength(memory).downcase.sub(' ', '-')
  end
end
