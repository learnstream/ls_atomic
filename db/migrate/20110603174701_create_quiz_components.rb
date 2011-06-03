class CreateQuizComponents < ActiveRecord::Migration
  def self.up
    create_table :quiz_components do |t|
      t.integer :quiz_id
      t.integer :component_id

      t.timestamps
    end
    
    add_index :quiz_components, :quiz_id
    add_index :quiz_components, :component_id
    add_index :quiz_components, [:quiz_id, :component_id], :unique => true
  end

  def self.down
    drop_table :quiz_components
  end
end
