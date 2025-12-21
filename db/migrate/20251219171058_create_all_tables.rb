class CreateAllTables < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :email, null: false
        t.string :password_digest, null: false
        t.string :first_name, null: false
        t.string :last_name, null: false
        t.index :email, unique: true, if_not_exists: true
      end
    end

    unless table_exists?(:student_profiles)
      create_table :student_profiles do |t|
        t.references :user, null: false
        t.string :group, null: false
      end
      add_foreign_key :student_profiles, :users, if_not_exists: true
      add_index :student_profiles, :user_id, unique: true, if_not_exists: true
    end

    unless table_exists?(:teacher_profiles)
      create_table :teacher_profiles do |t|
        t.references :user, null: false
        t.string :position, null: false
        t.string :academic_degree
      end
      add_foreign_key :teacher_profiles, :users, if_not_exists: true
      add_index :teacher_profiles, :user_id, unique: true, if_not_exists: true
    end

    unless table_exists?(:subjects)
      create_table :subjects do |t|
        t.string :name, null: false
        t.string :code, null: false
        t.integer :credits, default: 3
      end
      add_index :subjects, :code, unique: true, if_not_exists: true
    end

    unless table_exists?(:courses)
      create_table :courses do |t|
        t.references :subject, null: false
        t.references :teacher, null: false
        t.string :semester, null: false
        t.integer :year, null: false
        t.string :term, null: false
      end
      add_foreign_key :courses, :subjects, if_not_exists: true
      add_foreign_key :courses, :users, column: :teacher_id, if_not_exists: true
      add_index :courses, [:subject_id, :semester], unique: true, if_not_exists: true
    end

    unless table_exists?(:enrollments)
      create_table :enrollments do |t|
        t.references :student, null: false
        t.references :course, null: false
        t.string :status, default: "active"
      end
      add_foreign_key :enrollments, :users, column: :student_id, if_not_exists: true
      add_foreign_key :enrollments, :courses, if_not_exists: true
      add_index :enrollments, [:student_id, :course_id], unique: true, if_not_exists: true
    end

    unless table_exists?(:classrooms)
      create_table :classrooms do |t|
        t.string :number, null: false
        t.integer :capacity, default: 30
        t.string :building
      end
      add_index :classrooms, :number, unique: true, if_not_exists: true
    end

    unless table_exists?(:schedule_slots)
      create_table :schedule_slots do |t|
        t.references :course, null: false
        t.references :classroom, null: false
        t.integer :weekday, null: false
        t.time :start_time, null: false
        t.time :end_time, null: false
        t.string :lesson_type, null: false
      end
      add_foreign_key :schedule_slots, :courses, if_not_exists: true
      add_foreign_key :schedule_slots, :classrooms, if_not_exists: true
      add_index :schedule_slots, [:classroom_id, :weekday, :start_time], unique: true, if_not_exists: true
    end
  end
end