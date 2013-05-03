$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'sprockets_fs'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f }


RSpec.configure do |config|
  #config.fail_fast = true
 
  config.before(:all) do
    #File.create("log_special.log","Make #{Time.now}\n")
    #MongoLog.instance.coll.remove

    FileUtils.mkdir("/tmp/test_dirs") unless FileTest.exist?("/tmp/test_dirs")
  end

end
