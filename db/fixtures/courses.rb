# SeedFu.quiet = true
#
Course.seed(:id) do |s|
  s.id    = 1
  s.name = "Mechanics"
  s.description = "Review of Newtonian Mechanics"
end

Course.seed(:id) do |s|
  s.id    = 2
  s.name = "Calculus Tutorials"
  s.description = "Tutorials on calculus, trigonometry, and other subjects."
end



#Adds stuff for Calc tutorial.
dir_list = Dir["#{Rails.root}/lib/tasks/DataFiles/CalcTutorials/*"]
lesson = nil

dir_list.each_with_index do |tutorial, t|
  Dir["#{tutorial}/*"].each_with_index do |segment, index|
    file = File.open(segment, 'rb')
    contents = file.read
    file.close()
    lessons = Course.find(2).lessons
    if contents[0..6] == "#!META:"
      title = contents.split("\n")[0][/title\(([.]*[^\)\n)]*)\)/, 1]
      Lesson.seed(:id) do |s|
        s.id = lessons[t].id
        s.name = title
        s.order_number = t + 1
      end
      contents = contents.split("\n")[1..-1].join("\n") 
    end
    current_event = nil
    Event.seed(:lesson_id, :order_number) do |s|
      s.lesson_id = lessons[t].id
      s.order_number = index
      s.video_url = ""
      s.start_time = 0
      s.end_time = 0
    end
    note_id = Event.where(:lesson_id => lessons[t].id, :order_number => index).first.playable.id
    Note.seed(:id) do |s|
      s.id = note_id 
      s.content = contents
      s.is_document = true
    end
  end
end

