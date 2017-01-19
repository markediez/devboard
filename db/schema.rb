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

ActiveRecord::Schema.define(version: 20170118003642) do

  create_table "activity_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "developer_id"
    t.integer  "project_id"
    t.datetime "when"
    t.integer  "task_id"
    t.integer  "activity_type",   default: 0
    t.integer  "meeting_note_id"
    t.string   "commit_gh_id"
  end

  create_table "api_key_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assignments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "task_id"
    t.integer  "developer_account_id"
    t.integer  "priority"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.datetime "due_at"
    t.datetime "assigned_at"
    t.integer  "delay_count",          default: 0
  end

  create_table "commits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "sha"
    t.integer  "developer_account_id"
    t.integer  "project_id"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "committed_at"
    t.integer  "additions"
    t.integer  "deletions"
    t.integer  "total"
  end

  create_table "developer_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "developer_id"
    t.string   "email"
    t.string   "account_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "loginid"
    t.string   "name"
  end

  create_table "developers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "loginid"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "gh_personal_token"
    t.string   "gh_username"
    t.boolean  "active",              default: true
  end

  create_table "exception_filters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "concern"
    t.string   "pattern"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "kind"
    t.string   "value"
  end

  create_table "exception_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "subject",                               null: false
    t.text     "body",                    limit: 65535, null: false
    t.integer  "gh_issue_id"
    t.integer  "duplicated_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "task_id"
    t.integer  "exception_from_email_id"
    t.string   "email_from"
    t.integer  "project_id"
  end

  create_table "meeting_notes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "body",       limit: 65535
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "taken"
  end

  create_table "milestones", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "description",         limit: 65535
    t.datetime "due_on"
    t.datetime "completed_at"
    t.integer  "gh_milestone_number"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "project_id"
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "status",                    default: 0
    t.datetime "began"
    t.date     "finished"
    t.integer  "priority",                  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
    t.text     "description", limit: 65535
    t.date     "due"
  end

  create_table "repositories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "project_id"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "session_id",                   null: false
    t.text     "data",           limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_ticket"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "sprints", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "milestone_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.float    "points_attempted", limit: 24
    t.float    "points_completed", limit: 24
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.integer  "creator_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "due"
    t.string   "link"
    t.integer  "priority",                      default: 1
    t.integer  "difficulty"
    t.integer  "duration"
    t.string   "gh_issue_number"
    t.text     "details",         limit: 65535
    t.datetime "completed_at"
    t.integer  "milestone_id"
    t.float    "points",          limit: 24
    t.integer  "repository_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "loginid"
    t.boolean  "active",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "developer_id"
    t.datetime "logged_in_at"
  end

end
