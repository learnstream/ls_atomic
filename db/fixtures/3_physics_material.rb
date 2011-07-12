# Adds stuff for Physics Course.
# Note, Physics Course has course_id == 1
# See the courses seed-fu file 

# Components
f = File.open("#{Rails.root}/lib/tasks/DataFiles/Physics/PhysicsComponents.tsv", 'rb')
compMap = {}

f.each do |line|
  next if f.lineno == 1
  compData = line.split("\t")
  if compData[0].empty?
    Component.seed do |s|
      s.course_id = 1
      s.name = compData[3]
      s.description = compData[4]
    end
  else
    Component.seed(:id) do |s|
      s.id = compData[0]
      s.name = compData[3]
      s.description = compData[4]
    end
  end
  # Maps UniqueID => DB_id 
  compMap.merge!( { compData[1] => "#{Component.where(:name => compData[3]).first.id}" })
end
f.close()


# Lessons

lessons = Course.find(1).lessons
lessonMap = {}
# --------------------------------------
 
file = File.open("#{Rails.root}/lib/tasks/DataFiles/Physics/PhysicsLessons.tsv", 'rb')

file.each do |line|
  next if file.lineno == 1
  lessonData = line.split("\t")
  lesson = nil
  if lessonData[3].empty?   #No lesson_id from database in this table. Set order_number later.
    Lesson.seed do |s|
      s.course_id = 1
      s.name = lessonData[2]
    end
    lesson = Lesson.where(:name => lessonData[2]).first
    lessons << lesson   
  else
    Lesson.seed(:id) do |s|
      s.id = lessonData[3]
      s.course_id = 1
      s.name = lessonData[2]
    end
  end
  # Maps the UniqueLessonID to the database lesson_id
  lesson ||= Lesson.where(:name => lessonData[2]).first
  lessonMap.merge!({ lessonData[4] => "#{lesson.id}" })

  Event.seed(:lesson_id, :order_number) do |s|
    s.lesson_id = lesson.id 
    s.order_number = lessonData[8]
    s.video_url = lessonData[6]
    s.start_time = lessonData[16].to_i
    s.end_time = lessonData[17].to_i
  end
  event = Event.where(:lesson_id => lesson.id, :order_number => lessonData[8]).first
  component_tokens = lessonData[10].to_s.split(",").map{|e| Component.find(lessonMap[e]) }
  lessonData[12] == "text" ? answer_tokens = lessonData[13].to_s.split("&") : answer_tokens = [lessonData[13].to_s]

        #component_tokens.each { |c| quiz.components << Component.find(c)} 
        #answer_tokens.each { |a| quiz.answers.create!(:text => a ) }
  if event.playable.nil?
    if lessonData[7] == "Quiz"
      Quiz.seed do |s|
        s.course_id = 1
        s.in_lesson =  (lessonData[15] == "1") ? true : false
        s.answer_type = lessonData[12]
        s.explanation = lessonData[14]
        s.question = lessonData[11]
        s.answer_input = { :type => lessonData[12] }.to_json
        s.answer_output = { :type => "text" }.to_json
        s.components = component_tokens 
        s.events = [event]
      end
    elsif lessonData[7] == "Note"
      Note.seed do |s|
        s.content = lessonData[9] 
        s.events = [event]
      end
    end
  else
    if lessonData[7] == "Quiz"
      Quiz.seed(:id) do |s|
        s.id = event.playable.id
        s.course_id = 1
        s.in_lesson =  (lessonData[15] == "1") ? true : false
        s.answer_type = lessonData[12]
        s.explanation = lessonData[14]
        s.question = lessonData[11]
        s.answer_input = { :type => lessonData[12] }.to_json
        s.answer_output = { :type => "text" }.to_json
        s.events = [event]
      end
    elsif lessonData[7] == "Note"
      Note.seed(:id) do |s|
        s.id = event.playable.id 
        s.content = contents
        s.is_document = true
        s.events = [event]
      end
    end
  end
end


        #is there a better way to do this? I'll admit i'm a bit lost now in the quiz controller/model code. -NP
        quiz = Quiz.create!(:course_id => course,
                 :in_lesson => lesson_event["in_lesson"],
                 :answer_type => lesson_event["answer_type"],
                 :explanation => lesson_event["explanation"],
                 :question => lesson_event["question"],
                 :answer_input => { :type => lesson_event["answer_type"] }.to_json,
                 :answer_output => { :type => "text" }.to_json)

        component_tokens.each { |c| quiz.components << Component.find(c)} 
        answer_tokens.each { |a| quiz.answers.create!(:text => a ) }
        quiz.events << event



# Writes out the component map.
puts "The current component mapping is:"
puts "#{compMap}"
puts "Please record this somewhere!"


