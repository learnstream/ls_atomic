class QuizComponent < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :component
end
