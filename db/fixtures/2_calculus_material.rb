#Adds stuff for Calc tutorial.

component_map = make_calc_components()
lesson_map = make_calc_lessons(component_map)
quiz_map = make_calc_exercises(component_map)


# Writes out the component map.
puts "The current component mapping is:"
puts "#{component_map}"
puts "Please record this somewhere!"
puts "---------------------"
puts "The quiz mapping array is:"
puts quiz_map
puts "---------------------"
puts "The lesson mapping array is:"
puts lesson_map


# Components
def make_calc_components
  f = File.open("#{Rails.root}/lib/tasks/DataFiles/Calculus/CalculusComponents.tsv", 'rb')
  component_map = {}

  f.each do |line|
    next if f.lineno == 1 # Skip the first line, which has spreadsheet column headers
    data = line.split("\t")
    next_id = Component.count + 1

    component_id = data[0].empty? ? Component.count + 1 : data[0] 

    Component.seed(:id) do |s|
      s.id = component_id 
      s.course_id = 2
      s.name = data[3]
      s.description = data[4]
    end
    component_map[data[2]] = component_id

  end
  f.close()
  return component_map
end


# Lessons
#
def make_calc_lessons(component_map)
  lesson_map = [] 

  Dir["#{Rails.root}/lib/tasks/DataFiles/Calculus/CalcTutorials/*"].sort.each_with_index do |tutorial, t|
    lesson_id = nil
    Dir["#{tutorial}/*"].sort.each_with_index do |segment, index|
      file = File.open(segment, 'rb')
      contents = file.read
      file.close()

      if contents[0..6] == "#!META:"
        metadata = contents.split("\n")[0]

        title = metadata[/title\(([.]*[^\)\n)]*)\)/, 1]
        order_number = metadata[/order_num\(([.]*[^\)\n)]*)\)/, 1]

        lesson_components = metadata[/components\(([.]*[^\)\n)]*)\)/, 1]
        lesson_db_components = lesson_components.nil? ? [] : lesson_components.split(",").map{ |c| component_map[c] }

        lesson_db_id = metadata[/dbID\(([.]*[^\)\n)]*)\)/, 1]
        lesson_id = lesson_db_id.nil? ? Lesson.count + 1 : lesson_db_id.to_i

        Lesson.seed(:id) do |s|
          s.id = lesson_id
          s.course_id = 2
          s.name = title
          s.order_number = order_number 
          s.components = lesson_db_components.map { |c| Component.find(c) }
        end
        lesson_map << ["#{title}", lesson_id]

        segment_contents = contents.split("\n")[1..-1].join("\n") 
      end

      Event.seed(:lesson_id, :order_number) do |s|
        s.lesson_id = lesson_id 
        s.order_number = index
        s.video_url = ""
        s.start_time = 0
        s.end_time = 0
      end
      event = Event.where(:lesson_id => lesson_id, :order_number => index).first

      Note.seed(:id) do |s|
        s.id = event.playable.id unless event.playable.nil?
        s.content = segment_contents
        s.is_document = true
        s.events = [event]
      end
    end
  end

  return lesson_map

end

# Quizzes...
#

def make_calc_exercises(component_map)
  file = File.open("#{Rails.root}/lib/tasks/DataFiles/Calculus/CalculusExercises.tsv", 'rb')
  quiz_map = []

  file.each do |line|
    next if file.lineno == 1 # skip the spreadsheet header line

    data = line.split("\t")
    quiz_data = serialize_quiz(data, component_map)

    Quiz.seed(:id) do |s|
      s.id = quiz_data[:id]
      s.course_id = 2
      s.in_lesson = false
      s.question = quiz_data[:question]
      s.answer_type = quiz_data[:answer_type]
      s.answer_input = quiz_data[:answer_input]
      s.answer_output = quiz_data[:answer_output]
      s.components = quiz_data[:component_tokens].map { |c| Component.find(c) }
    end

    quiz_data[:answer].each do |a|
      Answer.seed(:quiz_id) do |s|
        s.quiz_id = quiz_data[:id]
        s.text = a 
      end
    end
    quiz_map << quiz_data[:id] 
  end
  file.close()
  return quiz_map
end


def serialize_quiz(quiz_array, component_map)

  answer_tokens = quiz_array[4..7]
  answer_type = quiz_array[3]
  quiz_id = quiz_array[10].nil? ? Quiz.count + 1 : quiz_array[10]

  quiz_data = {   
    :id => quiz_id,
    :component_tokens => quiz_array[0].to_s.split(",").map{|e| component_map[e] },
    :question => quiz_array[2],
    :answer_type => answer_type, 
    :answer_input => {:type => answer_type, :choices => answer_tokens}.to_json,
    :answer_output => {:type => "text"}.to_json, #depricated...?
    :answer => quiz_array[8].delete("\n").split("")
  }

  return quiz_data
end

