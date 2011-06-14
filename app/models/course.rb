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
    problemtexts = find_problems(document)
   
    count = 0 
    problemtexts.each { |problem|
      problemText = problem.first.chomp
      name = find_name(problemText)   
      statement = find_statement(problemText)
      @problem = problems.create(:name => name, :statement => statement)
      
   
      if @problem.save
      else
        flash.now[:notice] = "Only the first " + count.to_s + " problems out of " + problems.length.to_s + " were created. Please review your TeX and correct any errors." 
        render 'edit'
        return
      end
 
      array = problemText.scan(/\\begin{step}(.*?)\\end{step}/im)
        array.each {|step|
          stepText = step.first.chomp 
          @problem.steps.create!(:text => stepText, :order_number => 1)
        }

        document = document.sub(/\\begin{problem}.*?\\end{problem}/im,  "")
        count += 1
      }

    if @problem.save
      if(problemtexts.length == 1)
        flash[:success] = "Problem created!"
        redirect_to [@course, @problem]
      else
        flash[:success] = "Problems created! Please review the problems separately."
        redirect_to course_problems_path(@course)
      end
    else
      render 'edit'
    end
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

end
