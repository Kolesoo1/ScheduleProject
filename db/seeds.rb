# db/seeds.rb
puts "Начинаем заполнение базы данных..."

# Очистка данных
puts "Очистка существующих данных..."
ScheduleSlot.delete_all
Enrollment.delete_all
Course.delete_all
Classroom.delete_all
Subject.delete_all
TeacherProfile.delete_all
StudentProfile.delete_all
User.delete_all

puts "Создание администратора..."
admin = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Александр',
  last_name: 'Иванов',
  role: 'admin',
  confirmed_at: Time.current
)
puts "✓ Администратор: #{admin.email}"

puts "Создание преподавателя..."
teacher = User.new(
  email: 'teacher@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Мария',
  last_name: 'Петрова',
  role: 'teacher',
  confirmed_at: Time.current
)
teacher.save!(validate: false)

TeacherProfile.create!(
  user_id: teacher.id,
  position: 'Профессор',
  academic_degree: 'Доктор наук'
)
puts "✓ Преподаватель: #{teacher.email}"

puts "Создание студентов..."
students_data = [
  { email: 'student1@example.com', first_name: 'Алексей', last_name: 'Смирнов', group: 'CS-101' },
  { email: 'student2@example.com', first_name: 'Екатерина', last_name: 'Кузнецова', group: 'CS-102' },
  { email: 'student3@example.com', first_name: 'Дмитрий', last_name: 'Иванов', group: 'MATH-201' }
]

students = []
students_data.each do |data|
  student = User.new(
    email: data[:email],
    password: 'password123',
    password_confirmation: 'password123',
    first_name: data[:first_name],
    last_name: data[:last_name],
    role: 'student',
    confirmed_at: Time.current
  )
  student.save!(validate: false)

  StudentProfile.create!(
    user_id: student.id,
    group: data[:group]
  )

  students << student
  puts "✓ Студент: #{student.email}"
end

puts "Создание предметов..."
subjects = []
subjects_data = [
  { name: 'Программирование', code: 'CS101', credits: 5 },
  { name: 'Математический анализ', code: 'MATH101', credits: 6 },
  { name: 'Базы данных', code: 'CS201', credits: 4 }
]

subjects_data.each do |data|
  subject = Subject.create!(data)
  subjects << subject
  puts "✓ Предмет: #{subject.name}"
end

puts "Создание аудиторий..."
classrooms = []
classrooms_data = [
  { number: 101, building: 'Главный корпус', capacity: 30 },
  { number: 201, building: 'Главный корпус', capacity: 25 },
  { number: 301, building: 'Корпус Б', capacity: 40 }
]

classrooms_data.each do |data|
  classroom = Classroom.create!(data)
  classrooms << classroom
  puts "✓ Аудитория: #{classroom.building}, #{classroom.number}"
end

puts "Создание курсов..."
courses = []
courses_data = [
  {
    name: 'Основы программирования на Ruby',
    subject_id: subjects[0].id,
    teacher_id: teacher.id,
    semester: 1,
    year: 2024,
    term: 1
  },
  {
    name: 'Математический анализ для программистов',
    subject_id: subjects[1].id,
    teacher_id: teacher.id,
    semester: 1,
    year: 2024,
    term: 1
  }
]

courses_data.each do |data|
  course = Course.create!(data)
  courses << course
  puts "✓ Курс: #{course.name}"
end

puts "Создание расписания..."
schedule_data = [
  {
    course_id: courses[0].id,
    classroom_id: classrooms[0].id,
    weekday: 1,
    start_time: '09:00:00',
    end_time: '10:30:00',
    lesson_type: 'Лекция'
  },
  {
    course_id: courses[0].id,
    classroom_id: classrooms[1].id,
    weekday: 3,
    start_time: '14:00:00',
    end_time: '15:30:00',
    lesson_type: 'Практика'
  },
  {
    course_id: courses[1].id,
    classroom_id: classrooms[2].id,
    weekday: 2,
    start_time: '11:00:00',
    end_time: '12:30:00',
    lesson_type: 'Лекция'
  },
  {
    course_id: courses[1].id,
    classroom_id: classrooms[0].id,
    weekday: 4,
    start_time: '16:00:00',
    end_time: '17:30:00',
    lesson_type: 'Семинар'
  }
]

schedule_data.each_with_index do |slot, i|
  ScheduleSlot.create!(slot)
  weekday_name = case slot[:weekday]
                 when 1 then 'Понедельник'
                 when 2 then 'Вторник'
                 when 3 then 'Среда'
                 when 4 then 'Четверг'
                 when 5 then 'Пятница'
                 else "День #{slot[:weekday]}"
                 end
  puts "✓ Занятие: #{weekday_name} #{slot[:start_time]}-#{slot[:end_time]}"
end

puts "Запись студентов на курсы..."
enrollments_data = [
  { student_id: students[0].id, course_id: courses[0].id, status: 'active' },
  { student_id: students[0].id, course_id: courses[1].id, status: 'active' },
  { student_id: students[1].id, course_id: courses[0].id, status: 'active' },
  { student_id: students[2].id, course_id: courses[1].id, status: 'active' }
]

enrollments_data.each do |data|
  # Убрали enrolled_at, так как этого поля нет в таблице
  Enrollment.create!(data)
end
puts "✓ Создано #{enrollments_data.size} записей на курсы"

puts "\n" + "="*50
puts "БАЗА ДАННЫХ УСПЕШНО ЗАПОЛНЕНА!"
puts "="*50
puts "\nДанные для входа:"
puts "-" * 30
puts "Администратор:"
puts "  Email: admin@example.com"
puts "  Пароль: password123"
puts "\nПреподаватель:"
puts "  Email: teacher@example.com"
puts "  Пароль: password123"
puts "\nСтуденты:"
students.each_with_index do |student, i|
  puts "  #{i+1}. #{student.email} / password123"
end
puts "-" * 30

puts "\nСтатистика:"
puts "• Пользователей: #{User.count}"
puts "• Предметов: #{Subject.count}"
puts "• Курсов: #{Course.count}"
puts "• Аудиторий: #{Classroom.count}"
puts "• Занятий в расписании: #{ScheduleSlot.count}"
puts "• Записей на курсы: #{Enrollment.count}"