class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    # puts "**********#{row}"[1, "Pat", 12]
    student = Student.new()
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.count_all_students_in_grade_9
    sql = "select count(*) from students where grade = 9"
    row = DB[:conn].execute(sql)[0]
  end

  def self.students_below_12th_grade
    sql = "select count(*) from students where grade < 12"
    DB[:conn].execute(sql)[0]
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "select * from students"
    row=DB[:conn].execute(sql)  #
    # puts "********************#{row}"  #[[1, "Pat", "12"], [2, "Sam", "10"]]
    # row
    items = row.collect do |student_row|
      # puts "**********student_row::#{student_row}"
      new_student = Student.new_from_db(student_row)
    end
    # puts "***********#{items}"
    items
  end

  def self.all_students_in_grade_X(x)
    sql="select * from students where grade = ?"
    row=DB[:conn].execute(sql,x)  
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    # puts "************#{name}"
    sql="select * from students where name = ?"
    row = DB[:conn].execute(sql,name)[0]
    # puts "************#{found}"
    student=self.new_from_db(row)
  end

  def self.first_student_in_grade_10
    data=self.first_X_students_in_grade_10(1)[0]
    self.new_from_db(data)
    # sql="select * from students where grade = 10 LIMIT ?"
    # row = DB[:conn].execute(sql,x)
    # puts ""
    # puts "********************#{row}"
  end

  def self.first_X_students_in_grade_10(x)
    sql="select * from students where grade = 10 LIMIT ?"
    row = DB[:conn].execute(sql,x)
    # puts ""
    # puts "********************#{row}"
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
