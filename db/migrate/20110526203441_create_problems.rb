class CreateProblems < ActiveRecord::Migration
  def self.up
    create_table :problems do |t|
      t.string :name
      t.string :statement
      t.string :steps

      t.timestamps
    end
  end

  def self.down
    drop_table :problems
  end
end
