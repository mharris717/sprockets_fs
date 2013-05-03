env = MountApp::Application.assets

puts "env root: #{env.root}"

puts "each_file"
env.each_file do |f|
  puts f.inspect
end
puts "\n\n\n"

puts "each_entry /"
env.each_entry(env.root) do |f|
  puts f.inspect
end
puts "\n\n\n"

puts "each_logical_path"
env.each_logical_path do |f|
  puts f.inspect
end
puts "\n\n\n"

puts "paths"
env.paths.each do |f|
  puts f.inspect
end
puts "\n\n\n"