@students = [] # an empty array accessible to all methods
@list_of_saves = []

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save list"
  puts "4. Load list"
  puts "9. Exit"
end

def process(selection)
  feedback_message(selection)
  case selection
  when "1"
    input_students
  when "2"
    show_students
  when "3"
    select_save_file
  when "4"
    select_load_file
  when "9"
    update_git_ignore
    exit # this will cause the program to terminate
  else
    puts "I don't know what you meant, try again"
  end
end

def feedback_message(number)
  puts "You pressed #{number}"
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  name = STDIN.gets.chomp
  while !name.empty? do
    add_student(name)
    puts "Now we have #{@students.count} students"
    # get another name from the user
    name = STDIN.gets.chomp
  end
end

def add_student(name,cohort = :november)
  @students << {name: name, cohort: cohort.to_sym}
end

def show_students
  print_header
  print_student_list
  print_footer
end

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print_student_list
  @students.each do |student|
    puts "#{student[:name]} (#{student[:cohort]} cohort)"
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great students"
end

def select_save_file
  puts "File name (hit return for default): "
  filename = STDIN.gets.chomp
  filename == '' ? save_students : save_students(filename)
end

def save_students(filename = "students.csv")
  @list_of_saves << filename if !File.exists?(filename)
  file = File.open(filename, "w")
  @students.each do |student|
    file.puts [student[:name], student[:cohort]].join(",")
  end
  file.close
  puts "Saved to #{filename}"
end

def select_load_file
  puts "File name (hit return for default): "
  filename = STDIN.gets.chomp
  filename == '' ? load_students : load_students(filename)
end

def load_students(filename = "students.csv")
  file = File.open(filename,"r")
  file.readlines.each do |line|
    name, cohort = line.chomp.split(',')
    add_student(name,cohort)
  end
  file.close
  message_confirming_load(filename)
end

def load_file
  filename = ARGV.first
  if filename.nil?
    load_students
    return
  end
  if File.exists?(filename)
    load_students(filename)
  else
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

def message_confirming_load(filename = "students.csv")
  puts "Loaded students from #{filename}. There are now #{@students.count} students."
end

def load_saves
  file = File.open(".gitignore","r")
  file.readlines.each do |line|
    save_name = line.chomp
    @list_of_saves << save_name
  end
  file.close
end

def update_git_ignore
  file = File.open(".gitignore", "w")
  @list_of_saves.each do |save|
    file.puts save
  end
  file.close
  puts "'.gitignore' updated"
end

load_saves
load_file
interactive_menu
