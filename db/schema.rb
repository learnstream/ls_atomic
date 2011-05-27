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

ActiveRecord::Schema.define(:version => 20110526234226) do

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

  create_table "problems", :force => true do |t|
    t.string   "name"
    t.string   "statement"
    t.string   "steps"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
  end

  create_table "steps", :force => true do |t|
    t.string   "name"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
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

end
