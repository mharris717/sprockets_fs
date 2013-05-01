puts MountApp::Application.assets.class

load File.dirname(__FILE__) + "/../lib/sprockets_fs.rb"

parent_dir = "/mnt/hgfs/Code/orig/sprockets_fs/vol/mount_app/app/assets"
mount_dir = "/tmp/mount_rails"


env = MountApp::Application.assets
dir = SprocketsFS::SprocketsDir.new(:parent_dir => parent_dir, :env => env, :mount_dir => mount_dir)

FuseFS.start(dir,mount_dir)