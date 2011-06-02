class StepsController < ApplicationController
  before_filter :authenticate
  before_filter :only => [:create, :update] do 
   check_permissions(params)
  end

  def create
    problem_id = params[:step][:problem_id]
    problem = Problem.find(problem_id)

    if problem.nil?
      flash[:error] = "Something went wrong... you need to add steps to problems!"
      redirect_to root_path
      return
    end

    problem = Problem.find(problem_id)
    if problem.steps.last.nil?
      largest_step_number = 0
    else
      largest_step_number = problem.steps.last.order_number
    end

    @step = problem.steps.build(params[:step].merge(:order_number => largest_step_number + 1 ))
    
    if @step.save
      flash[:success] = "Step created!"
      redirect_to edit_step_path(@step)
    else
      flash[:error] = "Step could not be created. Make sure it isn't blank."
      redirect_to edit_problem_path(problem)
    end
  end

  def destroy
  end

  def update
    
    @step = Step.find(params[:id])
       
    if @step.update_attributes(params[:step])
      flash[:success] = "Step updated!"
      redirect_to edit_problem_path(@step.problem)
    else
      @video = Video.new
      @components = @step.problem.course.components
      render 'edit'
    end
  end

  def edit
    @step = Step.find(params[:id])
    @components = @step.problem.course.components
    @video = Video.new
    @videos = @step.videos
  end

  def help
    @step = Step.find(params[:id])
    @component_list = []
    @step.components.each do |component|
      @component_list << { :name => component.name,
                           :path => component_path(component) }
    end

    @video_list = []
    @step.videos.each do |video|
      @video_list << {  :name => video.name,
                        :url => video.url,
                        :start_time => video.start_time,
                        :end_time => video.end_time,
                        :description => video.description }
    end
    
    @response = { :components => @component_list, :videos =>  @video_list } 
    respond_to do |format|
      format.json { render :json => @response.to_json }
    end
  end

  private

    def check_permissions(params)

      course = Step.find(params[:id]).problem.course unless params[:id].nil? 
      course ||= Problem.find(params[:step][:problem_id]).course 

      unless current_user.can_edit?(course)
        flash[:error] = "You don't have permissions!"
        redirect_to root_path
        return false
      end 
    end

end
