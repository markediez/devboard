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

ActiveRecord::Schema.define(version: 20150519192504) do

  create_table "activity_logs", force: :cascade do |t|
    t.integer  "developer_id"
    t.integer  "project_id"
    t.datetime "when"
    t.integer  "task_id"
    t.integer  "activity_type",               default: 0
    t.integer  "meeting_note_id"
    t.string   "commit_gh_id",    limit: 255
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
  end

  create_table "meeting_notes", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "taken"
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

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id",     limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_ticket", limit: 255
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "tasks", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.integer  "creator_id"
    t.integer  "project_id"
    t.datetime "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "due"
    t.string   "link",            limit: 255
    t.integer  "priority",                    default: 1
    t.integer  "difficulty"
    t.integer  "duration"
    t.string   "gh_issue_number", limit: 255
    t.text     "details"
    t.integer  "assignee_id"
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
