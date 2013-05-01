load File.dirname(__FILE__) + "/../lib/sprockets_fs.rb"
load "~/code/orig/sprockets_fs/vol/mount_app/config/environment.rb"

parent_dir = "~/code/orig/sprockets_fs/vol/mount_app/app/assets"
mount_dir = "/tmp/mount_rails"


env = MountApp::Application.config.assets

require 'pp'
puts env.class
pp env
raise 'foo'
dir = SprocketsFS::SprocketsDir.new(:parent_dir => parent_dir, :env => env, :mount_dir => mount_dir)

FuseFS.start(dir,mount_dir)