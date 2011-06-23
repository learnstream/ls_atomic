class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.string :text
      t.integer :quiz_id

      t.timestamps
    end

    add_index :answers, :quiz_id
  end

  def self.down
    drop_table :answers
  end
end
