module LessonsHelper
  def fitName(lesson)
    name = lesson.name
    if (name.length > 20)
      name = name[0..17] + "..."
    end
    name
  end
end
