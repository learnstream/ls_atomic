class RemoveQuizTextLimit < ActiveRecord::Migration
  def self.up
    change_column :quizzes, :question, :text, :limit => nil
  end

  def self.down
    change_column :quizzes, :question, :text, :limit => 65536
  end
end
