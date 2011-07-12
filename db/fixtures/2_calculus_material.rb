#Adds stuff for Calc tutorial.

# Components
f = File.open("#{Rails.root}/lib/tasks/DataFiles/Calculus/CalculusComponents.tsv", 'rb')
compMap = {}

f.each do |line|
  next if f.lineno == 1
  compData = line.split("\t")
  if compData[0].empty?
    Component.seed do |s|
      s.course_id = 2
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

dir_list = Dir["#{Rails.root}/lib/tasks/DataFiles/Calculus/CalcTutorials/*"].sort
lessons = Course.find(2).lessons
puts dir_list
dir_list.each_with_index do |tutorial, t|
  Dir["#{tutorial}/*"].sort.each_with_index do |segment, index|
    puts Dir["#{tutorial}/*"].sort
    file = File.open(segment, 'rb')
    contents = file.read
    file.close()
    if contents[0..6] == "#!META:"
      title = contents.split("\n")[0][/title\(([.]*[^\)\n)]*)\)/, 1]
      lesson_components = contents.split("\n")[0][/components\(([.]*[^\)\n)]*)\)/, 1]
      lesson_components = lesson_components.nil? ? [] : lesson_components.split(",")
      if lessons[t].nil?
        Lesson.seed do |s|
          s.name = title
          s.order_number = t + 1
          s.course_id = 2
          s.components = lesson_components.map { |c| Component.find(c) }
        end
        lessons << Lesson.where(:name => title).first
      else
        Lesson.seed(:id) do |s|
          s.id = lessons[t].id
          s.name = title
          s.order_number = t + 1
          s.components = lesson_components.map { |c| Component.find(c) }
        end
      end
      contents = contents.split("\n")[1..-1].join("\n") 
    end
    puts lessons
    Event.seed(:lesson_id, :order_number) do |s|
      s.lesson_id = lessons[t].id
      s.order_number = index
      s.video_url = ""
      s.start_time = 0
      s.end_time = 0
    end
    event = Event.where(:lesson_id => lessons[t].id, :order_number => index).first

    if event.playable.nil?
      Note.seed do |s|
        s.content = contents
        s.is_document = true
        s.events = [event]
      end
    else
      Note.seed(:id) do |s|
        s.id = event.playable.id 
        s.content = contents
        s.is_document = true
        s.events = [event]
      end
    end
  end
end

file = File.open("#{Rails.root}/lib/tasks/DataFiles/Calculus/CalculusExercises.tsv", 'rb')
quizMap = []

file.each do |line|
  next if file.lineno == 1
  exerciseData = line.split("\t")
  component_tokens = exerciseData[0].to_s.split(",").map{|e| compMap[e] }
  answer_tokens = exerciseData[4..7]

  if exerciseData[10].nil?
    Quiz.seed do |s|
      s.course_id = 2
      s.in_lesson = false
      s.question = exerciseData[2]
      s.answer_type = exerciseData[3]
      s.answer_input = { :type => "multi", :choices => answer_tokens }.to_json
      s.answer_output = { :type => "text" }.to_json #is this depricated...?
      s.components = component_tokens.map { |c| Component.find(c) }
    end
    Answer.seed do |s|
      s.quiz_id = Quiz.where(:question => exerciseData[2]).first.id
      s.text = exerciseData[8].delete("\n")
    end
  else
    Quiz.seed(:id) do |s|
      s.id = exerciseData[10]
      s.course_id = 2
      s.in_lesson = false
      s.question = exerciseData[2]
      s.answer_type = exerciseData[3]
      s.answer_input = { :type => "multi", :choices => answer_tokens }.to_json
      s.answer_output = { :type => "text" }.to_json #is this depricated...?
      s.components = component_tokens.map { |c| Component.find(c) }
    end
    Answer.seed(:quiz_id) do |s|
      s.quiz_id = exerciseData[10]
      s.text = exerciseData[8].delete("\n")
    end
  end
  quizMap << Quiz.where(:question => exerciseData[2]).first.id
end
file.close()

# Writes out the component map.
puts "The current component mapping is:"
puts "#{compMap}"
puts "Please record this somewhere!"

puts "---------------------"
puts "The quiz mapping array is:"
puts quizMap
