class StudyController < ApplicationController
  before_filter :authenticate

  layout "study"

  def index
    @course = Course.find(params[:course_id])

    @quiz = nil
    count = 0
    while @quiz.nil?

      @memory = current_user.memories_due(@course).order[count]
      if @memory.nil? 
        render 'index'
        count = 0
        return
      end

      @quiz = @memory.component.quizzes.sample
      count += 1
    end

    redirect_to @quiz

#while @quiz.nil?
#  @memory = current_user.memories_due(@course).first 
#  if @memory.nil? 
#    render 'index'
#    return
#  end
#  
#  @quiz = @memory.component.quizzes.first
#  
#  if @quiz.nil?
#    @memory.view(0)
#  end
#end
#redirect_to @quiz

  end
end


