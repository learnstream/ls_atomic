class ModifyQuiz < ActiveRecord::Migration
  def self.up
    remove_column :quizzes, :problem_id
    remove_column :quizzes, :steps
    add_column :quizzes, :course_id, :integer
    add_column :quizzes, :in_lesson, :boolean, :default => 0
    add_column :quizzes, :explanation, :text
    add_index :quizzes, :course_id
  end

  def self.down
    add_column :quizzes, :problem_id, :integer
    add_column :quizzes, :steps, :string, :default => ""
    remove_index :quizzes, :course_id 
    remove_column :quizzes, :course_id
    remove_column :quizzes, :in_lesson
    remove_column :quizzes, :explanation
  end
end
