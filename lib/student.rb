require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end


  def self.create_table #  creates a table and gives table column names that match the attributes of an individual instance of student
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

  def self.create(name, grade)
    new_student = self.new
    new_student.id = name[0], grade[0]
    new_student.name = name[1], grade[1]
    new_student.grade = name[2], grade[2]

    new_student
  end


  def update
    sql = "UPDATE students SET name=?"
    DB[:conn].execute(sql, self.name)
  end


  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

end
