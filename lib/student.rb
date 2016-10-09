require_relative "../config/environment.rb"
require 'pry'
# Remember, you can access your database connection anywhere in this class
#  with DB[:conn]
class Student
  @@all = []
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade
    @@all << self
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, grade TEXT)")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if @id == nil
      sql = <<-SQL
      INSERT INTO students(name, grade)
      VALUES(?, ?)
      SQL

      DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    else
      self.update
    end
    self
  end

  def self.create(id = nil, name, grade)
    Student.new(id, name, grade).save
  end

  def self.new_from_db(array)
    studes = Student.create(array[0], array[1], array[2])
  end

  def update
    sql = <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, @name, @grade, @id)
  end

  def self.find_by_name(name)
    @@all.find{|student| student.name == name && student.id != nil}
  end
end
