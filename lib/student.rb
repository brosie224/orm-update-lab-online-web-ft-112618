require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id


  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
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
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self. grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    sql = <<-SQL
      SELECT * FROM students
      WHERE id = ?
    SQL

    new_student = Student.new
    new_student.id = DB[:conn].execute(sql, row)[0,0]
    new_student.name = DB[:conn].execute(sql, row)[0,1]
    new_student.grade = DB[:conn].execute(sql, row)[0,2]
    new_student
  end

end
