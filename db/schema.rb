# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110601171111) do

  create_table "components", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
  end

  add_index "components", ["course_id"], :name => "index_components_on_course_id"

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.string   "role",       :default => "student"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enrollments", ["course_id"], :name => "index_enrollments_on_course_id"
  add_index "enrollments", ["user_id", "course_id"], :name => "index_enrollments_on_user_id_and_course_id", :unique => true
  add_index "enrollments", ["user_id"], :name => "index_enrollments_on_user_id"

  create_table "memories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "component_id"
    t.decimal  "ease",         :default => 2.5
    t.decimal  "interval",     :default => 1.0
    t.integer  "views",        :default => 0
    t.integer  "streak",       :default => 0
    t.datetime "last_viewed"
    t.datetime "due",          :default => '2011-05-27 23:13:53'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memories", ["component_id"], :name => "index_memories_on_component_id"
  add_index "memories", ["user_id", "component_id"], :name => "index_memories_on_user_id_and_component_id", :unique => true
  add_index "memories", ["user_id"], :name => "index_memories_on_user_id"

  create_table "memory_ratings", :force => true do |t|
    t.integer  "memory_id"
    t.integer  "quality"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memory_ratings", ["memory_id"], :name => "index_memory_ratings_on_memory_id"

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

  create_table "steps", :force => true do |t|
    t.string   "name"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_number"
    t.integer  "problem_id"
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                      :null => false
    t.string   "persistence_token",                          :null => false
    t.string   "crypted_password",                           :null => false
    t.string   "password_salt",                              :null => false
    t.string   "single_access_token",                        :null => false
    t.string   "perishable_token",                           :null => false
    t.integer  "login_count",         :default => 0,         :null => false
    t.integer  "failed_login_count",  :default => 0,         :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "perm",                :default => "learner"
  end

  create_table "videos", :force => true do |t|
    t.string   "url"
    t.integer  "start_time",   :default => 0
    t.integer  "end_time"
    t.string   "name"
    t.integer  "component_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "videos", ["component_id"], :name => "index_videos_on_component_id"

end
