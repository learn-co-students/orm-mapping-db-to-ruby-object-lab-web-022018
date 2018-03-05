require "pry"

class Student
  attr_accessor :name, :grade, :id

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE if EXISTS students;
    SQL
    db = DB[:conn].execute(sql).first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("Select last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1;
    SQL
    # binding.pry
    row = DB[:conn].execute(sql,name).first
    self.new_from_db(row)
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students;
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(*)
      FROM students
      WHERE grade = 9;
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12;
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY students.id
      LIMIT ?;
    SQL

    DB[:conn].execute(sql, number).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY students.id
      LIMIT 1;
    SQL

    row = DB[:conn].execute(sql).first
    self.new_from_db(row)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      ORDER BY students.id;
    SQL

    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end
  end
end
