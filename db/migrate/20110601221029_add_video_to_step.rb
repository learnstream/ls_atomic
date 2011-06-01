class AddVideoToStep < ActiveRecord::Migration
  def self.up
    add_column :videos, :step_id, :integer 
    add_index :videos, :step_id
  end

  def self.down
    remove_column :videos, :step_id
    remove_index :videos, :setp_id
  end
end
