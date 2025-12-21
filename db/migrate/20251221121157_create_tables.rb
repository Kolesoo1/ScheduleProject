class CreateTables < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :first_name
      t.string :last_name
      t.timestamps
    end

    create_table :student_profiles do |t|
      t.bigint :user_id, null: false
      t.string :group
      t.timestamps

      t.foreign_key :users, column: :user_id
      t.index [:user_id], unique: true
    end

    create_table :teacher_profiles do |t|
      t.bigint :user_id, null: false
      t.string :position
      t.string :academic_degree
      t.timestamps

      t.foreign_key :users, column: :user_id
      t.index [:user_id], unique: true
    end

    create_table :subjects do |t|
      t.string :name, null: false
      t.string :code, null: false, index: { unique: true }
      t.integer :credits
      t.timestamps
    end

    create_table :classrooms do |t|
      t.integer :number, null: false
      t.integer :capacity
      t.string :building
      t.timestamps

      t.index [:number, :building], unique: true
    end

    create_table :courses do |t|
      t.string :name, null: false
      t.integer :subject_id, null: false
      t.bigint :teacher_id, null: false
      t.integer :semester
      t.integer :year
      t.integer :term
      t.timestamps

      t.foreign_key :subjects, column: :subject_id
      t.foreign_key :users, column: :teacher_id
    end

    create_table :enrollments do |t|
      t.bigint :student_id, null: false
      t.integer :course_id, null: false
      t.string :status
      t.timestamps

      t.foreign_key :users, column: :student_id
      t.foreign_key :courses, column: :course_id
      t.index [:student_id, :course_id], unique: true
    end

    create_table :schedule_slots do |t|
      t.integer :course_id, null: false
      t.bigint :classroom_id, null: false
      t.integer :weekday
      t.time :start_time
      t.time :end_time
      t.string :lesson_type
      t.timestamps

      t.foreign_key :courses, column: :course_id
      t.foreign_key :classrooms, column: :classroom_id
      t.index [:classroom_id, :weekday, :start_time, :end_time], unique: true, name: 'unique_classroom_schedule'
      t.index [:course_id, :weekday, :start_time, :end_time], unique: true, name: 'unique_course_schedule'
    end
  end
end