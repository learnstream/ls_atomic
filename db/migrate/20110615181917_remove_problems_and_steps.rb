class RemoveProblemsAndSteps < ActiveRecord::Migration
  def self.up
    drop_table :problems
    drop_table :steps
    drop_table :step_components
  end

  def self.down
    create_table "problems", :force => true do |t|
      t.string   "name"
      t.string   "statement"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "course_id"
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
    end

    create_table "step_components", :force => true do |t|
      t.integer  "step_id"
      t.integer  "component_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "step_components", ["component_id"], :name => "index_step_components_on_component_id"
    add_index "step_components", ["step_id", "component_id"], :name => "index_step_components_on_step_id_and_component_id", :unique => true
    add_index "step_components", ["step_id"], :name => "index_step_components_on_step_id"
  end

  create_table "steps", :force => true do |t|
    t.string   "name"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_number"
    t.integer  "problem_id"
  end
end
