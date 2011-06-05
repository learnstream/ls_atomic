class ProblemsController < ApplicationController
  before_filter :authenticate
  before_filter :only => [:create, :update, :new, :edit] do 
   check_permissions(params)
  end
 
  def create
    course = Course.find(params[:problem][:course_id])
    if course.nil? 
      flash[:error] = "You're trying to add to a course that doesn't exist"
      redirect_to root_path
      return
    end

    @problem = course.problems.build(params[:problem])

    if @problem.save
      flash[:success] = "Problem created!"
      redirect_to @problem
    else
      @course = course
      render 'new'
    end
   end

  def tex_create
    course = Course.find(params[:problem][:course_id])
    if course.nil? 
      flash[:error] = "You're trying to add to a course that doesn't exist"
      redirect_to root_path
      return
    end
  
    # Hack! We used the statement field of the form to the entire TeX input, and now we extract the problems.  
    original_text = params[:problem][:statement]
    problems = find_problems(original_text)
    if problems.empty?
      flash.now[:error] = "No problems found! Did you remember your \\begin{problem} and \\end{problem} tags?"
      @problem = course.problems.build(params[:problem])
      @problem.statement = original_text
      @course = course
      render 'new_tex'
      return
    end
   
    count = 0 
    problems.each { |problem|
      problemText = problem.first.chomp
      @problem = course.problems.build(params[:problem])
      @problem.name = find_name(problemText)   
      @problem.statement = find_statement(problemText)
      
   
      if @problem.save
      else
        flash.now[:notice] = "Only the first " + count.to_s + " problems out of " + problems.length.to_s + " were created. Please review your TeX and correct any errors." 
        @problem.statement = original_text
        @course = course
        render 'new_tex'
        return
      end
 
      array = problemText.scan(/\\begin{step}(.*?)\\end{step}/im)
        array.each {|step|
          stepText = step.first.chomp 
          @problem.steps.create!(:text => stepText, :order_number => 1)
        }

        original_text = original_text.sub(/\\begin{problem}.*?\\end{problem}/im,  "")
        count += 1
      }

    if @problem.save
      if(problems.length == 1)
        flash[:success] = "Problem created!"
        redirect_to @problem
      else
        flash[:success] = "Problems created! Please review the problems separately."
        redirect_to course
      end
    else
      @problem.statement = original_text
      @course = course
      render 'new_tex'
    end
  end

  def new
    @course = Course.find(params[:course_id])
    @problem = Problem.new  
  end

  def new_tex
    @course = Course.find(params[:course_id])
    @problem = Problem.new
  end 
  
  def update
    @problem = Problem.find(params[:id])

    if @problem.update_attributes(params[:problem])
      flash[:success] = "Problem updated!"
      redirect_to problem_path
    else
      @step = Step.new
      render 'edit' 
    end
  end

  def edit
    @problem = Problem.find(params[:id])
    @step = Step.new
  end

  def show
    @problem = Problem.find(params[:id])
    @steps = @problem.steps
    @course = @problem.course
  end

  def show_step
    @problem = Problem.find(params[:id])
    @step = @problem.steps[Integer(params[:step_number])-1]
    render :json => @step
  end

  private

    def check_permissions(params)

      course = Problem.find(params[:id]).course unless params[:id].nil? 
      course ||= Course.find(params[:course_id]) unless params[:course_id].nil?
      course ||= Course.find(params[:problem][:course_id]) 

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permission to do that!"
        redirect_to root_path
        return false
      end 
    end
    
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
