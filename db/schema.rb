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

ActiveRecord::Schema.define(:version => 20110704232321) do

  create_table "answers", :force => true do |t|
    t.text     "text"
    t.integer  "quiz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["quiz_id"], :name => "index_answers_on_quiz_id"

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
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enrollments", ["course_id"], :name => "index_enrollments_on_course_id"
  add_index "enrollments", ["user_id", "course_id"], :name => "index_enrollments_on_user_id_and_course_id", :unique => true
  add_index "enrollments", ["user_id"], :name => "index_enrollments_on_user_id"

  create_table "events", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "playable_id"
    t.string   "playable_type"
    t.string   "video_url"
    t.integer  "start_time"
    t.integer  "end_time"
    t.integer  "order_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["lesson_id"], :name => "index_events_on_lesson_id"
  add_index "events", ["playable_type", "playable_id"], :name => "index_events_on_playable_type_and_playable_id"

  create_table "lesson_components", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "component_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lesson_components", ["component_id"], :name => "index_lesson_components_on_component_id"
  add_index "lesson_components", ["lesson_id", "component_id"], :name => "index_lesson_components_on_lesson_id_and_component_id", :unique => true
  add_index "lesson_components", ["lesson_id"], :name => "index_lesson_components_on_lesson_id"

  create_table "lesson_statuses", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "user_id"
    t.integer  "event_id",   :default => -1
    t.boolean  "completed",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lesson_statuses", ["event_id"], :name => "index_lesson_statuses_on_event_id"
  add_index "lesson_statuses", ["lesson_id", "user_id"], :name => "index_lesson_statuses_on_lesson_id_and_user_id", :unique => true
  add_index "lesson_statuses", ["lesson_id"], :name => "index_lesson_statuses_on_lesson_id"
  add_index "lesson_statuses", ["user_id"], :name => "index_lesson_statuses_on_user_id"

  create_table "lessons", :force => true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.integer  "order_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lessons", ["course_id"], :name => "index_lessons_on_course_id"

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
    t.integer  "streak"
    t.decimal  "ease"
    t.integer  "interval"
  end

  add_index "memory_ratings", ["memory_id"], :name => "index_memory_ratings_on_memory_id"

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_document", :default => false
  end

  create_table "quiz_components", :force => true do |t|
    t.integer  "quiz_id"
    t.integer  "component_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quiz_components", ["component_id"], :name => "index_quiz_components_on_component_id"
  add_index "quiz_components", ["quiz_id", "component_id"], :name => "index_quiz_components_on_quiz_id_and_component_id", :unique => true
  add_index "quiz_components", ["quiz_id"], :name => "index_quiz_components_on_quiz_id"

  create_table "quizzes", :force => true do |t|
    t.text     "question"
    t.text     "answer_input"
    t.text     "answer_output"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.boolean  "in_lesson",     :default => false
    t.text     "explanation"
  end

  add_index "quizzes", ["course_id"], :name => "index_quizzes_on_course_id"

  create_table "responses", :force => true do |t|
    t.string   "answer"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_been_rated", :default => false
  end

  add_index "responses", ["quiz_id"], :name => "index_responses_on_quiz_id"
  add_index "responses", ["user_id"], :name => "index_responses_on_user_id"

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
    t.integer  "step_id"
  end

  add_index "videos", ["component_id"], :name => "index_videos_on_component_id"
  add_index "videos", ["step_id"], :name => "index_videos_on_step_id"

end
