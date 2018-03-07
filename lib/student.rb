require 'pry'
class Student
  attr_accessor :id, :name, :grade
  def self.new_from_db(row)
    student=Student.new
    student.id=row[0]
    student.name=row[1]
    student.grade=row[2]
    student
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
      SELECT id, name, grade FROM students
    SQL
    data = DB[:conn].execute(sql)
    data.map {|x| new_from_db(x)}
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT id, name, grade FROM students WHERE name = ?
    SQL
    data = DB[:conn].execute(sql, name)
    new_from_db(data[0])
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT id, name, grade FROM students WHERE grade = 9
    SQL
    data = DB[:conn].execute(sql)
    data.map {|x| new_from_db(x)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT id, name, grade FROM students WHERE grade < 12
    SQL
    data = DB[:conn].execute(sql)
    data.map {|x| new_from_db(x)}
  end

  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      SELECT id, name, grade FROM students WHERE grade = 10 LIMIT ?
    SQL
    data = DB[:conn].execute(sql, number)
    data.map {|x| new_from_db(x)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT id, name, grade FROM students WHERE grade = 10 LIMIT 1
    SQL
    student = DB[:conn].execute(sql)
    new_from_db(student[0])
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT id, name, grade FROM students WHERE grade = ?
    SQL
    data = DB[:conn].execute(sql, grade)
    data.map {|x| new_from_db(x)}
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
