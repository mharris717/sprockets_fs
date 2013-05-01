require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

if true
describe "SprocketsFs" do

  let(:dir) do
    SprocketsFS::SprocketsDir.new(:parent_dir => parent_dir)
  end
  let(:parent_dir) do
    setup_dir file_hash
  end
  def parent_file(path)
    File.read("#{parent_dir}/#{path}")
  end

  describe "Unit" do
    let(:file_hash) do
      {"main.js" => "var abc = 42;", "widgets/stuff.js" => "var widget = 'Green'"}
    end

    it 'read file' do
      dir.read_file("/main.js").should == parent_file("main.js")
    end
    it 'has files' do
      dir.files.size.should == file_hash.size
    end
    it 'has dirs' do
      dir.dirs.should == ["widgets"]
    end

    it 'contents has dirs' do
      dir.contents("/").sort.should == ["main.js","widgets"]
    end
    it 'sub contents' do
      dir.contents("/widgets").should == ["stuff.js"]
    end
  end

  describe "coffee" do

    let(:file_hash) do
      {"double.js.coffee" => "double = (x) -> x * 2"}
    end

    it 'converts to js' do
      dir.read_file("/double.js").should == CoffeeScript.compile(file_hash["double.js.coffee"]).strip
    end
    it 'coffee read is raw' do
      dir.read_file("/double.js.coffee").should == file_hash["double.js.coffee"]
    end
    it 'js version is file' do
      dir.should be_file("/double.js")
    end

    it 'contents has js' do
      dir.contents("/").should include("double.js")
    end
  end

  describe "write" do
    let(:file_hash) do
      {"zzz.js" => "abc = 42;"}
    end

    describe "raw" do
      before do
        dir.write_to "/abc.js","var abc = 42;"
      end

      it 'read back' do
        dir.read_file("/abc.js").strip.should == 'var abc = 42;'
      end
    end

    describe "coffee" do
      before do
        dir.write_to "/double.js.coffee","double = (x) -> x * 2"
      end

      it 'read coffee' do
        dir.read_file("/double.js.coffee").strip.should == "double = (x) -> x * 2"
      end

      it 'read js' do
        dir.read_file("/double.js").should =~ /double = function/
      end

      it 'write to js fails' do
        dir.can_write?("/double.js").should_not be
      end
    end
  end

  describe "erb" do
    let(:file_hash) do
      {"index.html.erb" => "<% if true %> abc <% end %>"}
    end

    it 'read parsed' do
      dir.read_file("/index.html").strip.should == "abc"
    end
  end

  if false
  describe "Integration" do
    it "smoke" do
      2.should == 2
    end

    it 'read' do
      File.read("/tmp/test_sp9/main.js").should == "var abc = 42;"
    end
  end
end
end
end

describe 'Rails' do
  include_context "fork"

  let(:cmds) do
    puts 'cmds call'
    rails = File.expand_path(File.dirname(__FILE__)+"/../vol/mount_app")
    file = File.expand_path(File.dirname(__FILE__)+"/../vol/mount_app_runner.rb")

    "cd #{rails} && rails runner #{file}"
  end

  def wait_until_mounted
    (0...150).each do 
      return if Dir["/tmp/mount_rails/*"].size > 0
      sleep(0.1)
    end
    raise 'not mounted'
  end

  before do
    wait_until_mounted
  end

  it 'smoke' do
    puts "rails smoke"
    #sleep(100000)
    2.should == 2
  end

  it 'read root' do
    Dir["/tmp/mount_rails/*"].sort.should == %w(images javascripts stylesheets).map { |x| "/tmp/mount_rails/#{x}" }
  end

  it 'read js folder' do
    exp = %w(application.js widgets.js widgets.js.coffee main.js).map { |x| "/tmp/mount_rails/javascripts/#{x}" }.sort
    Dir["/tmp/mount_rails/javascripts/*"].sort.should == exp
  end

  it 'read coffee' do
    File.read("/tmp/mount_rails/javascripts/widgets.js.coffee").strip.should == "double = (x) -> x * 2"
  end

  it 'read js' do
    File.read("/tmp/mount_rails/javascripts/widgets.js").strip.size.should > 0
    #File.read("/tmp/mount_rails/javascripts/widgets.js").strip.should =~ /double = function/
  end

  it 'read js basic' do
    File.read("/tmp/mount_rails/javascripts/main.js").strip.should == "var abc = 42;"
    #File.read("/tmp/mount_rails/javascripts/widgets.js").strip.should =~ /double = function/
  end




end
