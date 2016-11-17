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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161117211301) do

  create_table "activity_logs", force: :cascade do |t|
    t.integer  "developer_id"
    t.integer  "project_id"
    t.datetime "when"
    t.integer  "task_id"
    t.integer  "activity_type",               default: 0
    t.integer  "meeting_note_id"
    t.string   "commit_gh_id",    limit: 255
  end

  create_table "api_key_users", force: :cascade do |t|
    t.string   "name"
    t.string   "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ar_internal_metadata", ["key"], name: "sqlite_autoindex_ar_internal_metadata_1", unique: true

  create_table "assignments", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "developer_id"
    t.integer  "priority"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "due_at"
    t.datetime "assigned_at"
    t.integer  "delay_count",  default: 0
  end

  create_table "commits", force: :cascade do |t|
    t.string   "sha",                  limit: 255
    t.integer  "developer_account_id"
    t.integer  "project_id"
    t.string   "message",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "committed_at"
    t.integer  "additions"
    t.integer  "deletions"
    t.integer  "total"
  end

  create_table "developer_accounts", force: :cascade do |t|
    t.integer  "developer_id"
    t.string   "email",        limit: 255
    t.string   "account_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "loginid"
    t.string   "name"
  end

  create_table "developers", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "loginid",             limit: 255
    t.string   "email",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_content_type", limit: 255
    t.datetime "avatar_updated_at"
    t.string   "gh_personal_token",   limit: 255
    t.string   "gh_username",         limit: 255
    t.boolean  "active",                          default: true
  end

  create_table "meeting_notes", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "taken"
  end

  create_table "milestones", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "due_on"
    t.datetime "completed_at"
    t.integer  "gh_milestone_number"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "status",                  default: 0
    t.datetime "began"
    t.date     "finished"
    t.integer  "priority",                default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link",        limit: 255
    t.text     "description"
    t.string   "gh_repo_url", limit: 255
    t.date     "due"
  end

  create_table "repositories", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "gh_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id",     limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_ticket", limit: 255
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "sprints", force: :cascade do |t|
    t.integer  "milestone_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.float    "points_attempted"
    t.float    "points_completed"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.integer  "creator_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "due"
    t.string   "link",            limit: 255
    t.integer  "priority",                    default: 1
    t.integer  "difficulty"
    t.integer  "duration"
    t.string   "gh_issue_number", limit: 255
    t.text     "details"
    t.datetime "completed_at"
    t.integer  "milestone_id"
    t.float    "points"
  end

  create_table "users", force: :cascade do |t|
    t.string   "loginid",      limit: 255
    t.boolean  "active",                   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "developer_id"
    t.datetime "logged_in_at"
  end

end
