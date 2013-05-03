require 'rubygems'
require 'sprockets'
require 'mharris_ext'
require 'rfusefs'
require 'coffee-script'

class String
  def starts_with?(str)
    sub = self[0...(str.length)]
    sub == str
  end
end



module SprocketsFS
  class SprocketsDir
    include FromHash
    attr_accessor :parent_dirs, :mount_dir
    def parent_dir=(dir)
      self.parent_dirs = [dir]
    end

    fattr(:env) do
      ML.log "Made Env"
      res = Sprockets::Environment.new
      parent_dirs.each do |dir|
        res.append_path dir
      end
      res
    end
    def convert_to_relative(file)
      file = file.to_s if file
      parent_dirs.each do |dir|
        if file.starts_with?(dir)
          return file.gsub("#{dir}/","")
        end
      end
      raise "can't convert #{file} to relative, dirs are\n"+parent_dirs.join("\n")
      nil
    end
    def convert_to_absolute(file,safe=true)
      file = file.to_s if file
      parent_dirs.each do |dir|
        base = "#{dir}/#{file}"
        return base if FileTest.exist?(base)
      end
      raise "can't convert #{file} to absolute" if safe
      nil
    end
    def files
      res = []
      env.each_file do |f|
        res << convert_to_relative(f)
      end
      res - ["rails.png"]
    end
    def dirs
      res = []
      files.each do |f|
        if f.split("/").size > 1
          res << File.dirname(f)
        end
      end
      res
    end

    def file?(path)
      files.each do |f|
        return true if f == path[1..-1]
        if f.split(".").size > 2
          short = f.split(".")[0..-2].join(".")
          return true if short == path[1..-1]
        end
      end
      false
    end
    def directory?(path)
      path == "/" || dirs.include?(path[1..-1])
    end

    def contents(path)
      all = files
      res = if path == '/'
        all.select { |x| x.split("/").size == 1 } + dirs.select { |x| x.split("/").size == 1 }
      else
        all.select do |f|
          f.starts_with?(path[1..-1])
        end.map { |f| f.gsub("#{path[1..-1]}/","") }
      end.uniq

      res = res.map do |f|
        if f =~ /\.coffee$/
          [f,f.gsub(/\.coffee$/,"")]
        elsif f =~ /\.erb$/
          [f,f.gsub(/\.erb$/,"")]
        else
          f
        end
      end.flatten

      puts "contents #{res.size}"

      res
    end

    def unprocessed_parent_relative_file(file)
      files.each do |possible_parent|
        if possible_parent.starts_with?(file) && possible_parent.length > file.length
          return possible_parent
        end
      end
      nil
    end

    def read_file(path)
      ML.log("path #{path}") do
        base = convert_to_absolute(path[1..-1],false)
        if base
          File.read(base).strip
        else
          env.find_asset(path[1..-1]).to_s.strip
        end
      end
    end
    def size(path)
      read_file(path).size
    end

    def can_write?(path)
      #base = convert_to_absolute("#{path[1..-1]}.coffee",false) || convert_to_absolute("#{path[1..-1]}.erb",false)
      base = unprocessed_parent_relative_file(path[1..-1])
      if base
        false
      else
        true
      end
    end

    def write_to(path,contents)
      full = convert_to_absolute(path[1..-1],false)
      if !full
        if parent_dirs.size == 1
          full = "#{parent_dirs.first}#{path}"
        else
          raise "can't write"
        end
      end

      File.create full, contents
    end
  end
end

%w(log rails).each do |f|
  load File.dirname(__FILE__) + "/sprockets_fs/#{f}.rb"
end