# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_21_121740) do
  create_table "classrooms", force: :cascade do |t|
    t.string "building"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.integer "number", null: false
    t.datetime "updated_at", null: false
    t.index ["number", "building"], name: "index_classrooms_on_number_and_building", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "semester"
    t.integer "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.integer "term"
    t.datetime "updated_at", null: false
    t.integer "year"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.string "status"
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id", "course_id"], name: "index_enrollments_on_student_id_and_course_id", unique: true
  end

  create_table "schedule_slots", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.time "end_time"
    t.string "lesson_type"
    t.time "start_time"
    t.datetime "updated_at", null: false
    t.integer "weekday"
    t.index ["classroom_id", "weekday", "start_time", "end_time"], name: "unique_classroom_schedule", unique: true
    t.index ["course_id", "weekday", "start_time", "end_time"], name: "unique_course_schedule", unique: true
  end

  create_table "student_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "group"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_student_profiles_on_user_id", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.integer "credits"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_subjects_on_code", unique: true
  end

  create_table "teacher_profiles", force: :cascade do |t|
    t.string "academic_degree"
    t.datetime "created_at", null: false
    t.string "position"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_teacher_profiles_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "student"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "courses", "subjects"
  add_foreign_key "courses", "users", column: "teacher_id"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users", column: "student_id"
  add_foreign_key "schedule_slots", "classrooms"
  add_foreign_key "schedule_slots", "courses"
  add_foreign_key "student_profiles", "users"
  add_foreign_key "teacher_profiles", "users"
end
