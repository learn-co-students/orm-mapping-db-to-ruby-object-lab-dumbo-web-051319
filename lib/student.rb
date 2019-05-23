require "pry"
class Student
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name = nil, grade = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    Student.new(row[0], row[1], row[2])
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    data_array = DB[:conn].execute(sql)
    data_array.map{|row| Student.new(row[0], row[1], row[2])}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
        SELECT * FROM students WHERE students.name = "#{name}";
    SQL
    row = DB[:conn].execute(sql)
    self.new_from_db(row.flatten)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
        SELECT * FROM students WHERE students.grade = 9;
    SQL
    rows = DB[:conn].execute(sql)
    rows.map {|row| self.new_from_db(row.flatten)}
  end
  def self.students_below_12th_grade
    sql = <<-SQL
        SELECT * FROM students WHERE students.grade < 12;
    SQL
    rows = DB[:conn].execute(sql)
    rows.map {|row| self.new_from_db(row.flatten)}
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
        SELECT * FROM students WHERE students.grade = 10;
    SQL
    rows = DB[:conn].execute(sql)
    rows.map {|row| self.new_from_db(row.flatten)}[0..num-1]
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
        SELECT * FROM students WHERE students.grade = 10;
    SQL
    rows = DB[:conn].execute(sql)
    rows.map {|row| self.new_from_db(row.flatten)}[0]
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
        SELECT * FROM students WHERE students.grade = #{grade};
    SQL
    rows = DB[:conn].execute(sql)
    rows.map {|row| self.new_from_db(row.flatten)}
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
