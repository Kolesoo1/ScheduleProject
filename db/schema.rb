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

ActiveRecord::Schema[8.1].define(version: 2025_12_21_082816) do
  create_table "classrooms", force: :cascade do |t|
    t.string "building"
    t.integer "capacity", default: 30
    t.string "number", null: false
    t.index ["number"], name: "index_classrooms_on_number", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "semester", null: false
    t.integer "subject_id", null: false
    t.integer "teacher_id", null: false
    t.string "term", null: false
    t.integer "year", null: false
    t.index ["subject_id", "semester"], name: "index_courses_on_subject_id_and_semester", unique: true
    t.index ["subject_id"], name: "index_courses_on_subject_id"
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "course_id", null: false
    t.string "status", default: "active"
    t.integer "student_id", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["student_id", "course_id"], name: "index_enrollments_on_student_id_and_course_id", unique: true
    t.index ["student_id"], name: "index_enrollments_on_student_id"
  end

  create_table "schedule_slots", force: :cascade do |t|
    t.integer "classroom_id", null: false
    t.integer "course_id", null: false
    t.time "end_time", null: false
    t.string "lesson_type", null: false
    t.time "start_time", null: false
    t.integer "weekday", null: false
    t.index ["classroom_id", "weekday", "start_time"], name: "index_schedule_slots_on_classroom_id_and_weekday_and_start_time", unique: true
    t.index ["classroom_id"], name: "index_schedule_slots_on_classroom_id"
    t.index ["course_id"], name: "index_schedule_slots_on_course_id"
  end

  create_table "student_profiles", force: :cascade do |t|
    t.string "group", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_student_profiles_on_user_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code", null: false
    t.integer "credits", default: 3
    t.string "name", null: false
    t.index ["code"], name: "index_subjects_on_code", unique: true
  end

  create_table "teacher_profiles", force: :cascade do |t|
    t.string "academic_degree"
    t.string "position", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_teacher_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "password_digest", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
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
