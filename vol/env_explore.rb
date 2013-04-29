load File.dirname(__FILE__) + "/../lib/sprockets_fs.rb"

parent_dir = File.dirname(__FILE__) + "/../spec/data/parent"
dir = SprocketsFS::SprocketsDir.new(:parent_dir => parent_dir)
$env = dir.env

def env
  $env
end

class Object
  def pretty_methods
    res = local_methods.map do |m|
      m = m.to_s
      m = m[0..-2] if m[-1..-1] == '='
      m
    end
    res.uniq.each { |x| puts x.to_sym }
  end

  
end

env.each_entry do |f|
  puts f
end

str = "each_entry
each_file
each_logical_path"
