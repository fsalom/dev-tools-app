#  example

require 'xcodeproj'

# sudo gem update xcodeproj
# ruby addFile.rb

project_path = 'utils.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts project

file_group = project["utils"]
puts project

# file_group.new_file("../GeneratedFiles/Sample1.swift")

# project.save()
