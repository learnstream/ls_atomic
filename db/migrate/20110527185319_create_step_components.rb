class CreateStepComponents < ActiveRecord::Migration
  def self.up
    create_table :step_components do |t|
      t.integer :step_id
      t.integer :component_id

      t.timestamps
    end
    add_index :step_components, :step_id
    add_index :step_components, :component_id
    add_index :step_components, [:step_id, :component_id], :unique => true
  end


  def self.down
    drop_table :step_components
  end
end
