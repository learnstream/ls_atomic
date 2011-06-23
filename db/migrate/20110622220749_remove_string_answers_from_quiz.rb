class RemoveStringAnswersFromQuiz < ActiveRecord::Migration
  def self.up
    remove_column :quizzes, :answer
  end

  def self.down
  end
end
