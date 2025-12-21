student = User.create!(
  email: 'student@university.ru',
  password: '123456',
  first_name: 'Иван',
  last_name: 'Иванов'
)

teacher = User.create!(
  email: 'teacher@university.ru',
  password: '123456',
  first_name: 'Петр',
  last_name: 'Петров'
)

StudentProfile.create!(user: student, group: 'ПИ-21-1')
TeacherProfile.create!(
  user: teacher,
  position: 'Доцент',
  academic_degree: 'Кандидат наук'
)

math = Subject.create!(
  name: 'Математический анализ',
  code: 'MATH-101',
  credits: 4
)

classroom = Classroom.create!(
  number: 'A-101',
  capacity: 30,
  building: 'Корпус A'
)

course = Course.create!(
  subject: math,
  teacher: teacher,
  semester: 'Осень 2024',
  year: 2024,
  term: 'autumn'
)

Enrollment.create!(
  student: student,
  course: course,
  status: 'active'
)

ScheduleSlot.create!(
  course: course,
  classroom: classroom,
  weekday: 1,
  start_time: '09:00',
  end_time: '10:30',
  lesson_type: 'lecture'
)