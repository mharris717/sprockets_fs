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
      ML.log "Made Env"
      res = Sprockets::Environment.new
      res.append_path parent_dir
      res
    end
    def files
      res = []
      env.each_file do |f|
        res << f.to_s.gsub("#{parent_dir}/","")
      end
     # puts "got files #{res.size}"
      #puts res.inspect
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
     # puts "contents for #{path} #{env.class}"
      #puts env.inspect
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

    def read_file(path)
      ML.log("path #{path}") do
        base = "#{parent_dir}#{path}"
        res = if FileTest.exist?(base)
          puts "Read_file #{path} exists"
          File.read(base).strip

        else
          asset = env.find_asset(path[1..-1])
         # ML.log "asset type: #{asset.content_type} #{asset.inspect}"
          text = asset.to_s.strip

          if text.blank?
            self.env!
            p = path[1..-1]+".coffee"
            puts "finding #{path} #{p} with coffee added"
            text = env.find_asset(p).to_s.strip
            puts "got text #{text}"
          end

          text

        end
        #puts "Read_file #{path} #{res}"
        res
      end
    end
    def size(path)
      read_file(path).size
    end

    def can_write?(path)
      base = "#{parent_dir}#{path}.coffee"
      if FileTest.exist?(base)
        false
      else
        true
      end
    end

    def write_to(path,contents)
      full = "#{parent_dir}#{path}"
      File.create full, contents
    end
  end
end

%w(log).each do |f|
  load File.dirname(__FILE__) + "/sprockets_fs/#{f}.rb"
end