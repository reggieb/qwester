# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130111121500) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.string   "namespace"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "qwester_answer_stores", :force => true do |t|
    t.string   "session_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "qwester_answer_stores_answers", :id => false, :force => true do |t|
    t.integer "answer_id"
    t.integer "answer_store_id"
  end

  create_table "qwester_answer_stores_questionnaires", :id => false, :force => true do |t|
    t.integer "questionnaire_id"
    t.integer "answer_store_id"
  end

  create_table "qwester_answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "value"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "position"
    t.integer  "cope_index",  :default => 0
  end

  create_table "qwester_answers_rule_sets", :id => false, :force => true do |t|
    t.integer "answer_id"
    t.integer "rule_set_id"
  end

  create_table "qwester_ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "qwester_ckeditor_assets", ["assetable_type", "assetable_id"], :name => "qwester_idx_ckeditor_assetable"
  add_index "qwester_ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "qwester_idx_ckeditor_assetable_type"

  create_table "qwester_questionnaires", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "button_image_file_name"
    t.string   "button_image_content_type"
    t.integer  "button_image_file_size"
    t.datetime "button_image_updated_at"
  end

  create_table "qwester_questionnaires_questions", :force => true do |t|
    t.integer  "questionnaire_id"
    t.integer  "question_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qwester_questions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "ref"
    t.boolean  "multi_answer"
  end

  create_table "qwester_rule_sets", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "rule"
    t.string   "link_text"
  end

end
