class CreateQuizzes < ActiveRecord::Migration
  def self.up
    create_table :quizzes do |t|
      t.integer :problem_id
      t.string :steps
      t.string :question
      t.text :answer_input
      t.string :answer
      t.text :answer_output

      t.timestamps
    end

    add_index :quizzes, :problem_id
  end

  def self.down
    drop_table :quizzes
  end
end
