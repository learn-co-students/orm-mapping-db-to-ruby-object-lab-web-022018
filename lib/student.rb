class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
      select * from students
    SQL
    DB[:conn].execute(sql).collect do |x| self.new_from_db(x) end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      select * from students where name = ? limit 1
    SQL
    DB[:conn].execute(sql, name).collect do |x| self.new_from_db(x) end.first
  end
  
  def self.count_all_students_in_grade_9
    sql = <<-SQL
      select count (*) from students where grade = 9
    SQL
    DB[:conn].execute(sql).collect do |x| self.new_from_db(x) end
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      select * from students where grade < 12
    SQL
    DB[:conn].execute(sql).collect do |x| self.new_from_db(x) end
  end
  
  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      select * from students where grade = 10 order by students.id limit?
    SQL
    DB[:conn].execute(sql, number).collect do |x| self.new_from_db(x) end
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
      select * from students where grade = 10
    SQL
    DB[:conn].execute(sql).collect do |x| self.new_from_db(x) end.first
  end
  
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      select * from students where grade = grade
    SQL
    DB[:conn].execute(sql).collect do |x| self.new_from_db(x) end
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
