class Course < ActiveRecord::Base

  attr_accessor :document
  attr_accessible :name, :description

  has_many :components
  has_many :problems
  has_many :enrollments, :dependent => :destroy
  has_many :users, :through => :enrollments

  validates :name, :presence => true

  def teacher_enrollments
    enrollments.where(:role => "teacher")
  end

  def student_enrollments
    enrollments.where(:role => "student")
  end

  def students
    student_enrollments.map { |e| e.user } 
  end

  def teachers
    teacher_enrollments.map { |e| e.user }
  end
  
  def populate_with_tex(document)

    # Find Problems
    problemtexts = find_problems(document)

    problemCount = 0 
    problemtexts.each { |problem|
      problemText = problem.first.chomp
      name = find_name(problemText)   
      statement = find_statement(problemText)

      if statement.empty?
        errors.add("TeX Parser", ": missing problem statement")
      end

      @problem = problems.create(:name => name, :statement => statement)


      if @problem.save
      else
        errors.add("TeX Parser", ": only the first " + problemCount.to_s + " problems out of " + problemtexts.length.to_s + " were created.")
        return {:success => false, :problems_added => problemtexts.first(problemCount)}
      end

      array = problemText.scan(/\\begin{step}(.*?)\\end{step}/im)
      array.each {|step|
        stepText = step.first.chomp 
        @problem.steps.create!(:text => stepText, :order_number => 1)
      }

      document = document.sub(/\\begin{problem}.*?\\end{problem}/im,  "")
      problemCount += 1
    }

    # Find Components
    cmpTexts = find_components(document)

    cmpCount = 0
    cmpTexts.each { |cmp|
      @component = components.create(:name => cmp)

      if @component.save
      else
        errors.add("TeX Parser", ": only the first " + cmpCount.to_s + " components out of " + cmpTexts.length.to_s + " were created")
        return {:success => false, :problems_added => nil} 
      end
      cmpCount += 1
    }

    return {:success => true, :problems_added => nil} 
    

  end

  private
    def find_problems(text)
      return text.scan(/\\begin{problem}(.*?)\\end{problem}/im)
    end

    def find_name(text)
      statement = text.scan(/\\begin{name}(.*?)\\end{name}/im)
      text = statement.map{ |x| x[0]}.join
      return text.chomp
    end

    def find_statement(text)
      statement = text.scan(/\\begin{statement}(.*?)\\end{statement}/im)
      text = statement.map{ |x| x[0]}.join
      return text.chomp
    end

    def find_components(text)
      text = text.split('\section{components}').drop(1)[0]
      if(text)
        block =  text.scan(/\\begin{itemize}(.*?)\\end{itemize}/im)
        component_block = block.flatten[0]
        return component_block.split('\item ').drop(1).map{|x| x.chomp}
      else
        return []
      end
    end


end
