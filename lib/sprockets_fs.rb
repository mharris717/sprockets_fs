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
    attr_accessor :parent_dir, :mount_dir
    fattr(:env) do
      res = Sprockets::Environment.new
      res.append_path parent_dir
      res
    end
    def files
      res = []
      env.each_file do |f|
        res << f.to_s.gsub("#{parent_dir}/","")
      end
      res
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
      if path == '/'
        all.select { |x| x.split("/").size == 1 } + dirs.select { |x| x.split("/").size == 1 }
      else
        all.select do |f|
          f.starts_with?(path[1..-1])
        end.map { |f| f.gsub("#{path[1..-1]}/","") }
      end
    end

    def read_file(path)
      env[path[1..-1]].to_s.strip
    end
    def size(path)
      read_file(path).size
    end
  end
end