class FixStepProblemAssociations < ActiveRecord::Migration
  def self.up
    add_column :steps, :problem_id, :integer
    remove_column :problems, :steps
  end

  def self.down
    remove_colum :steps, :problem_id
    add_column :problems, :steps, :string
  end
end
