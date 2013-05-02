$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'sprockets_fs'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f }


RSpec.configure do |config|
  config.fail_fast = true
  files = {"main.js" => "var abc = 42;", "widgets/stuff.js" => "var widget = 'Green'"}
  parent_dir = setup_dir(files)

  mount_dir = "/tmp/test_sp9"
  gem_name = "sprockets_fs"

  SpecForks.add "ruby ~/code/orig/#{gem_name}/bin/#{gem_name} -p #{parent_dir} -m #{mount_dir}"

  config.before(:all) do
    File.create("log_special.log","Make #{Time.now}\n")
    #MongoLog.instance.coll.remove

    FileUtils.rm_r mount_dir if FileTest.exist?(mount_dir)
    `mkdir #{mount_dir}`
    
    SpecForks.start!
  end
  config.after(:all) do
    SpecForks.kill!
  end
end
