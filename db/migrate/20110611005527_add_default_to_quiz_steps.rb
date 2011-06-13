class AddDefaultToQuizSteps < ActiveRecord::Migration
  def self.up
    change_column :quizzes, :steps, :string, :default => ""
  end

  def self.down
    change_column :quizzes, :steps, :string, :default => nil
  end
end
