class QuizQuestionToText < ActiveRecord::Migration
  def self.up
    change_column :quizzes, :question, :text, :limit => 65536
  end

  def self.down
    change_column :quizzes, :question, :string
  end
end
