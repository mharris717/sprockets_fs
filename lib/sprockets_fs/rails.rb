module SprocketsFS
  class Mount
    include FromHash
    fattr(:parent_dir) do
      File.expand_path(".")
    end
    fattr(:mount_dir) do
      File.expand_path("./asset_fs")
    end

    def parse!
      require 'optparse'
      OptionParser.new do |opts|
        opts.banner = "Usage: sprockets_fs"

        opts.on("-m", "--mount-point MOUNT_POINT", "Mount Point") do |v|
          self.mount_dir = File.expand_path(v)
        end

        opts.on("-p", "--parent-dir PARENT_DIR", "Parent Dir") do |v|
          self.parent_dir = File.expand_path(v)
        end
      end.parse!
    end

    fattr(:app_name) do
      File.read("#{parent_dir}/config/environment.rb").scan(/([a-z]+)::Application/i).flatten.first
    end
    fattr(:app_obj) do
      eval(app_name)::Application
    end

    def mount_rails!
      FileUtils.mkdir(mount_dir) unless FileTest.exist?(mount_dir)

      load "#{parent_dir}/config/environment.rb"

      env = app_obj.assets
      dir = SprocketsFS::SprocketsDir.new(:parent_dir => "#{parent_dir}/app/assets", :env => env, :mount_dir => mount_dir)

      FuseFS.start(dir,mount_dir)
    end

    def mount_regular!
      dir = SprocketsFS::SprocketsDir.new(:parent_dir => parent_dir, :mount_dir => mount_dir)

      FuseFS.start(dir,mount_dir)
    end

    def mount!
      if FileTest.exist?("#{parent_dir}/config/environment.rb")
        mount_rails!
      else
        mount_regular!
      end
    end

    class << self
      def parsed
        res = new
        res.parse!
        res
      end
    end
  end
end