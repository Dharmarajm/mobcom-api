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

ActiveRecord::Schema.define(version: 20180315070856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_versions", force: :cascade do |t|
    t.string "version_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "call_logs", force: :cascade do |t|
    t.integer "from_employee_id"
    t.integer "to_employee_id"
    t.integer "to_contact_id"
    t.string "start_time"
    t.string "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "pincode"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "mobile_number"
    t.string "telephone_number"
    t.bigint "client_id"
    t.string "designation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_contacts_on_client_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "mobile_number"
    t.string "email"
    t.string "employee_id"
    t.string "designation"
    t.string "date_of_birth"
    t.string "street"
    t.string "pincode"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "status"
    t.float "ctc", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "message_logs", force: :cascade do |t|
    t.integer "from_employee_id"
    t.integer "to_employee_id"
    t.integer "to_contact_id"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_employees", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_project_employees_on_employee_id"
    t.index ["project_id"], name: "index_project_employees_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.float "budget"
    t.bigint "client_id"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_projects_on_client_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_sheets", force: :cascade do |t|
    t.date "date"
    t.float "hours"
    t.bigint "project_id"
    t.bigint "employee_id"
    t.boolean "approval_status"
    t.float "revised_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "attendance_log", default: true
    t.index ["employee_id"], name: "index_time_sheets_on_employee_id"
    t.index ["project_id"], name: "index_time_sheets_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.bigint "role_id"
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.index ["auth_token"], name: "index_users_on_auth_token"
    t.index ["employee_id"], name: "index_users_on_employee_id"
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "contacts", "clients"
  add_foreign_key "project_employees", "employees"
  add_foreign_key "project_employees", "projects"
  add_foreign_key "projects", "clients"
  add_foreign_key "time_sheets", "employees"
  add_foreign_key "time_sheets", "projects"
  add_foreign_key "users", "employees"
  add_foreign_key "users", "roles"
end
